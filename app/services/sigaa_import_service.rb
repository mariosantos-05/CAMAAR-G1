require 'json'

class SigaaImportService
  class InvalidFileError < StandardError; end

  REQUIRED_SUBJECT_KEYS = %w[code name class] 
  
  REQUIRED_CLASS_KEYS = %w[classCode semester time]
  
  REQUIRED_MEMBER_FILE_KEYS = %w[code classCode semester dicente]
  
  REQUIRED_STUDENT_KEYS = %w[nome matricula curso usuario email ocupacao formacao]

  def initialize(file_path)
    @file_path = file_path
  end

  def call
    file_content = File.read(@file_path)
    
    begin
      json_data = JSON.parse(file_content)
    rescue JSON::ParserError
      raise InvalidFileError, "O arquivo não é um JSON válido."
    end

    unless json_data.is_a?(Array)
      raise InvalidFileError, "O JSON deve ser uma lista (Array) de objetos."
    end

    ActiveRecord::Base.transaction do
      json_data.each_with_index do |entry, index|
        if entry.key?('class') 
          process_classes_file(entry, index)
        elsif entry.key?('dicente')
          process_members_file(entry, index)
        else
          raise InvalidFileError, "O objeto na linha #{index + 1} não foi reconhecido (não possui chave 'class' nem 'dicente')."
        end
      end
    end
  end

  private

  def validate_keys!(data, required_keys, context_message)
    required_keys.each do |key|
      value = data[key]
      if value.nil? || (value.respond_to?(:strip) && value.strip.empty?)
        raise InvalidFileError, "Erro #{context_message}: O campo obrigatório '#{key}' está ausente ou vazio."
      end
    end
  end

  def process_classes_file(entry, index)
    validate_keys!(entry, REQUIRED_SUBJECT_KEYS, "na Matéria (item #{index + 1})")

    validate_keys!(entry['class'], REQUIRED_CLASS_KEYS, "na Turma da matéria '#{entry['code']}'")

    subject = Subject.find_or_create_by(code: entry['code']) do |s|
      s.name = entry['name']
    end
    subject.update(name: entry['name'])

    class_info = entry['class']
    Turma.find_or_create_by(
      class_code: class_info['classCode'],
      semester: class_info['semester'],
      subject: subject
    ) do |t|
      t.time = class_info['time']
    end
  end

  def process_members_file(entry, index)
    validate_keys!(entry, REQUIRED_MEMBER_FILE_KEYS, "no cabeçalho da Turma (item #{index + 1})")

    if entry['dicente']
      entry['dicente'].each_with_index do |student_data, student_index|
        validate_keys!(student_data, REQUIRED_STUDENT_KEYS, "no Aluno ##{student_index + 1} da turma '#{entry['code']}'")
      end
    end

    subject = Subject.find_by(code: entry['code'])
    unless subject
      return 
    end

    turma = Turma.find_by(
      subject: subject,
      class_code: entry['classCode'],
      semester: entry['semester']
    )
    return unless turma 

    entry['dicente'].each do |student_data|
      member = Member.find_or_create_by(matricula: student_data['matricula']) do |m|
        m.nome = student_data['nome']
        m.curso = student_data['curso']
        m.usuario = student_data['usuario']
        m.email = student_data['email']
        m.ocupacao = student_data['ocupacao']
        m.formacao = student_data['formacao']
      end
      
      turma.members << member unless turma.members.exists?(member.id)
    end
  end
end