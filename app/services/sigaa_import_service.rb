require 'json'

class SigaaImportService
  class InvalidFileError < StandardError; end

  REQUIRED_SUBJECT_KEYS = %w[code name class] 
  REQUIRED_CLASS_KEYS = %w[classCode semester time]
  
  REQUIRED_MEMBER_FILE_KEYS = %w[code classCode semester dicente]
  
  REQUIRED_STUDENT_KEYS = %w[nome matricula curso email ocupacao formacao]

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
          raise InvalidFileError, "Objeto não reconhecido na linha #{index + 1}."
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
    validate_keys!(entry['class'], REQUIRED_CLASS_KEYS, "na Turma")

    nome_completo = "#{entry['name']} (#{entry['code']} - #{entry['class']['classCode']})"
    semestre = entry['class']['semester']

    turma = Turma.find_or_create_by(nome: nome_completo, semestre: semestre) do |t|
      t.is_active = true
    end
    
    turma.update(nome: nome_completo)
  end

  def process_members_file(entry, index)
    validate_keys!(entry, REQUIRED_MEMBER_FILE_KEYS, "no cabeçalho da Turma")

    if entry['dicente']
      entry['dicente'].each_with_index do |student_data, s_index|
        validate_keys!(student_data, REQUIRED_STUDENT_KEYS, "no Aluno ##{s_index + 1}")
      end
    end

    turma = Turma.where(semestre: entry['semester']).find do |t|
      t.nome.include?(entry['code']) && t.nome.include?(entry['classCode'])
    end

    unless turma
      return
    end

    if entry['dicente']
      entry['dicente'].each do |student_data|
        usuario = Usuario.find_or_create_by(matricula: student_data['matricula']) do |u|
          u.nome = student_data['nome']
          u.email = student_data['email']
          u.profile = 'Aluno'
          u.status = true
          u.departamento_id = 1
        end

        Vinculo.find_or_create_by(usuario: usuario, turma: turma) do |v|
          v.papel_turma = 0 
        end
      end
    end
  end
end