require 'json'

class SigaaImportService
  class InvalidFileError < StandardError; end

  REQUIRED_SUBJECT_KEYS = %w[code name class]
  REQUIRED_CLASS_KEYS = %w[classCode semester time]
  REQUIRED_MEMBER_FILE_KEYS = %w[code classCode semester dicente]

  # Chaves específicas para Alunos
  REQUIRED_STUDENT_KEYS = %w[nome matricula curso email ocupacao formacao]

  # Chaves específicas para Professores (Docente não tem 'curso', tem 'departamento')
  REQUIRED_TEACHER_KEYS = %w[nome usuario email ocupacao formacao departamento]

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

    { success: true, message: "Importação realizada com sucesso" }
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

    turma = Turma.find_or_initialize_by(nome: nome_completo, semestre: semestre)
    turma.is_active = true
    turma.save!
  end

  def process_members_file(entry, index)
    validate_keys!(entry, REQUIRED_MEMBER_FILE_KEYS, "no cabeçalho da Turma")

    # 1. Validação dos Alunos
    if entry['dicente']
      entry['dicente'].each_with_index do |student_data, s_index|
        validate_keys!(student_data, REQUIRED_STUDENT_KEYS, "no Aluno ##{s_index + 1}")

        # 'matricula' pode vir como integer ou string no JSON
        unless student_data['matricula'].to_s.match?(/^\d+$/)
          raise InvalidFileError, "Erro no Aluno ##{s_index + 1}: A matrícula deve conter apenas números."
        end
      end
    end

    # 2. Validação do Docente (NOVO)
    if entry['docente']
      validate_keys!(entry['docente'], REQUIRED_TEACHER_KEYS, "no Docente")
    end

    # Busca a turma correspondente
    turma = Turma.where(semestre: entry['semester']).find do |t|
      t.nome.include?(entry['code']) && t.nome.include?(entry['classCode'])
    end

    return unless turma

    # --- PROCESSAMENTO UNIFICADO (Alunos e Professores) ---

    # Processa Docente (Papel 1)
    if entry['docente']
      process_single_user(entry['docente'], 'Professor', turma, 1)
    end

    # Processa Discentes (Papel 0)
    if entry['dicente']
      entry['dicente'].each do |student_data|
        process_single_user(student_data, 'Aluno', turma, 0)
      end
    end
  end

  # Método genérico que aplica a regra de Primeiro Acesso para TODOS
  def process_single_user(data, profile, turma, papel)
    # Tenta 'matricula' (alunos) ou 'usuario' (docentes/alunos)
    matricula = data['matricula'] || data['usuario']
    return if matricula.blank?

    usuario = Usuario.find_or_initialize_by(matricula: matricula.to_s)
    is_new = usuario.new_record?

    usuario.nome = data['nome']
    usuario.email = data['email']
    usuario.profile = profile
    usuario.departamento_id = 1

    # REGRA DE PRIMEIRO ACESSO (Válida para Aluno e Professor):
    # Se é novo, nasce sem senha (nil) e com status false (pendente).
    if is_new
      usuario.status = false
    end

    usuario.save!

    Vinculo.find_or_create_by(usuario: usuario, turma: turma) do |v|
      v.papel_turma = papel
    end
  end
end