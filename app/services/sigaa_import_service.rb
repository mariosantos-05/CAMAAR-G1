require 'json'

class SigaaImportService
  class InvalidFileError < StandardError; end

  REQUIRED_SUBJECT_KEYS = %w[code name class]
  REQUIRED_CLASS_KEYS = %w[classCode semester time]
  REQUIRED_MEMBER_FILE_KEYS = %w[code classCode semester dicente]
  REQUIRED_STUDENT_KEYS = %w[nome matricula curso email ocupacao formacao]
  REQUIRED_TEACHER_KEYS = %w[nome usuario email ocupacao formacao departamento]

  # Inicializa o serviço com o caminho do arquivo.
  #
  # Args: file_path (String).
  def initialize(file_path)
    @file_path = file_path
  end

  # Executa a lógica principal de importação.
  #
  # Args: Nenhum.
  # Returns: Hash { success: true, message: String }.
  # Side Effects: Lê arquivo, altera Banco de Dados (Transação).
  def call
    json_data = parse_json_file

    ActiveRecord::Base.transaction do
      json_data.each_with_index do |entry, index|
        process_entry(entry, index)
      end
    end

    { success: true, message: "Importação realizada com sucesso" }
  end

  private

  # Lê e valida o formato JSON do arquivo.
  #
  # Args: Nenhum.
  # Returns: Array de Hashes.
  # Side Effects: Leitura de disco.
  def parse_json_file
    content = File.read(@file_path)
    data = JSON.parse(content)
    
    raise InvalidFileError, "O JSON deve ser uma lista (Array) de objetos." unless data.is_a?(Array)
    data
  rescue JSON::ParserError
    raise InvalidFileError, "O arquivo não é um JSON válido."
  end

  # Roteador que decide qual tipo de processamento usar (Turma ou Membros).
  #
  # Args: entry (Hash), index (Integer).
  # Returns: nil.
  # Side Effects: Nenhum direto.
  def process_entry(entry, index)
    if entry.key?('class')
      process_classes_file(entry, index)
    elsif entry.key?('dicente')
      process_members_file(entry, index)
    else
      raise InvalidFileError, "Objeto não reconhecido na linha #{index + 1}."
    end
  end

  # Processa a criação de uma Matéria/Turma.
  #
  # Args: entry (Hash), index (Integer).
  # Returns: Boolean (save!).
  # Side Effects: Cria registro na tabela Turma.
  def process_classes_file(entry, index)
    validate_keys!(entry, REQUIRED_SUBJECT_KEYS, "na Matéria (item #{index + 1})")
    validate_keys!(entry['class'], REQUIRED_CLASS_KEYS, "na Turma")

    nome_completo = "#{entry['name']} (#{entry['code']} - #{entry['class']['classCode']})"
    
    turma = Turma.find_or_initialize_by(nome: nome_completo, semestre: entry['class']['semester'])
    turma.is_active = true
    turma.save!
  end

  # Processa a importação de alunos e professores para uma turma.
  # REFATORADO: Dividido em validação, busca e persistência para baixar Score.
  #
  # Args: entry (Hash), index (Integer).
  # Returns: nil.
  # Side Effects: Cria registros de Usuario e Vinculo.
  def process_members_file(entry, index)
    validate_members_payload(entry, index)

    turma = find_turma(entry)
    return unless turma

    persist_members(entry, turma)
  end

  # Validações estruturais do arquivo de membros.
  #
  # Args: entry (Hash), index (Integer).
  # Returns: nil (raise error se falhar).
  # Side Effects: Nenhum.
  def validate_members_payload(entry, index)
    validate_keys!(entry, REQUIRED_MEMBER_FILE_KEYS, "no cabeçalho da Turma")
    validate_students_data(entry['dicente']) if entry['dicente']
    validate_keys!(entry['docente'], REQUIRED_TEACHER_KEYS, "no Docente") if entry['docente']
  end

  # Itera sobre as listas e chama a persistência individual.
  #
  # Args: entry (Hash), turma (Turma).
  # Returns: nil.
  # Side Effects: Chama process_single_user.
  def persist_members(entry, turma)
    process_single_user(entry['docente'], 'Professor', turma, 1) if entry['docente']
    
    return unless entry['dicente']
    
    entry['dicente'].each do |student| 
      process_single_user(student, 'Aluno', turma, 0)
    end
  end

  # Valida dados específicos de cada aluno na lista.
  #
  # Args: students_list (Array).
  # Returns: nil.
  # Side Effects: Nenhum.
  def validate_students_data(students_list)
    students_list.each_with_index do |student, index|
      validate_keys!(student, REQUIRED_STUDENT_KEYS, "no Aluno ##{index + 1}")
      
      unless student['matricula'].to_s.match?(/^\d+$/)
        raise InvalidFileError, "Erro no Aluno ##{index + 1}: A matrícula deve conter apenas números."
      end
    end
  end

  # Encontra a turma baseada no código e semestre.
  #
  # Args: entry (Hash).
  # Returns: Turma ou nil.
  # Side Effects: Consulta ao banco.
  def find_turma(entry)
    Turma.where(semestre: entry['semester']).find do |t|
      t.nome.include?(entry['code']) && t.nome.include?(entry['classCode'])
    end
  end

  # Coordena a criação/atualização do usuário e seu vínculo.
  #
  # Args: data (Hash), profile (String), turma (Turma), papel (Integer).
  # Returns: Vinculo.
  # Side Effects: DB Save.
  def process_single_user(data, profile, turma, papel)
    matricula = data['matricula'] || data['usuario']
    return if matricula.blank?

    usuario = persist_usuario(matricula.to_s, data, profile)
    create_vinculo(usuario, turma, papel)
  end

  # Cria ou atualiza o Usuário.
  #
  # Args: matricula (String), data (Hash), profile (String).
  # Returns: Usuario.
  # Side Effects: DB Save.
  def persist_usuario(matricula, data, profile)
    usuario = Usuario.find_or_initialize_by(matricula: matricula)
    
    setup_new_user(usuario, profile) if usuario.new_record?

    # Atualiza dados cadastrais
    usuario.nome = data['nome']
    usuario.email = data['email']
    usuario.save!
    usuario
  end

  # Configurações iniciais para novos usuários.
  #
  # Args: usuario (Usuario), profile (String).
  # Returns: nil.
  # Side Effects: Altera atributos do objeto.
  def setup_new_user(usuario, profile)
    usuario.profile = profile
    usuario.departamento_id = 1
    usuario.status = false
    usuario.password = "Mudar123" if usuario.respond_to?(:password=)
  end

  # Cria o vínculo entre usuário e turma se não existir.
  #
  # Args: usuario (Usuario), turma (Turma), papel (Integer).
  # Returns: Vinculo.
  # Side Effects: DB Create.
  def create_vinculo(usuario, turma, papel)
    Vinculo.find_or_create_by(usuario: usuario, turma: turma) do |v|
      v.papel_turma = papel
    end
  end

  # Valida presença de chaves obrigatórias num hash.
  #
  # Args: data (Hash), required_keys (Array), context (String).
  # Returns: nil.
  # Side Effects: Raises InvalidFileError.
  def validate_keys!(data, required_keys, context)
    required_keys.each do |key|
      if data[key].blank?
        raise InvalidFileError, "Erro #{context}: O campo obrigatório '#{key}' está ausente ou vazio."
      end
    end
  end
end