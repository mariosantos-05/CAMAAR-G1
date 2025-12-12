require 'csv'

# Controlador responsável pela orquestração das funcionalidades administrativas.
# Gerencia o painel de controle, visualização de resultados por departamento,
# importação de dados via integração SIGAA e exportação de relatórios em CSV.
#
# @see ApplicationController
class AdminsController < ApplicationController
  # Garante que apenas usuários com perfil 'Admin' acessem os métodos desta classe.
  before_action :require_admin

  # Renderiza o painel principal (Dashboard) da área administrativa.
  #
  # Args:
  #   Nenhum.
  #
  # Returns:
  #   Renderiza a view 'management' (HTML).
  #
  # Side Effects:
  #   Nenhum.
  def management
  end

  # Recupera e lista as turmas acadêmicas, filtrando pelo departamento do administrador
  # logado.
  #
  # @return [void] Renderiza a view 'results'.
  #
  # @note Efeitos Colaterais:
  #   - Define a variável de instância `@turmas` com as turmas filtradas.
  #   - Executa consulta de leitura no banco de dados (Turma).
  def results
    prefixo = current_user&.departamento_id == 2 ? "MAT" : "CIC"
    @turmas = Turma.where("nome LIKE ?", "%(#{prefixo}%")
  end

  # Inicializa a interface para upload de arquivos de importação.
  #
  # Args:
  #   Nenhum.
  #
  # Returns:
  #   Renderiza a view 'new_import'.
  #
  # Side Effects:
  #   Nenhum.
  def new_import
  end

  # Processa a requisição de upload para importação de dados do SIGAA.
  # Valida a presença do arquivo e delega o processamento de validação/persistência
  # ao método `attempt_import_process`.
  #
  # @param params [Hash] Contém o arquivo enviado (`params[:file]`).
  #
  # @return [void] Redireciona o fluxo da requisição.
  #
  # @note Efeitos Colaterais:
  #   - Redireciona caso o arquivo esteja ausente.
  #   - Chama o método de importação.
  def create_import
    uploaded_file = params[:file]
    return redirect_missing_file if uploaded_file.nil?

    attempt_import_process(uploaded_file.path)
  end

  # Recupera e exibe as respostas detalhadas submetidas para uma turma específica.
  #
  # @param params [Hash] Deve conter `params[:turma_id]` (Integer).
  #
  # @return [void] Renderiza a view 'show_respostas'.
  #
  # @note Efeitos Colaterais:
  #   - Define variáveis de instância `@turma` e `@respostas`.
  #   - Executa consultas complexas (`includes`) no banco de dados para evitar N+1 queries.
  def show_respostas
    @turma = Turma.find(params[:turma_id])
    forms = Form.where(turma_id: @turma.id)
    @respostas = Resposta.where(form_id: forms.pluck(:id))
                         .includes(:usuario, form: { template: :questions })
  end

  # Monta a geração e o download do relatório de respostas em formato CSV.
  #
  # @param params [Hash] Deve conter `params[:turma_id]` (Integer).
  #
  # @return [void] Inicia o download do arquivo CSV (stream) ou redireciona.
  #
  # @note Efeitos Colaterais:
  #   - Define `@turma`.
  #   - Gera um arquivo CSV em memória e o envia ao navegador.
  #   - Redireciona para `admin_results_path` com `alert` se a turma não tiver respostas.
  def export_csv
    @turma = Turma.find(params[:turma_id])
    
    questions, answers = load_export_data
    return redirect_empty_turma if answers.empty?

    csv_content = generate_csv_string(questions, answers)
    send_csv_file(csv_content)
  end

  private

  # Filtro de segurança (Authorization Guard).
  # Verifica se o usuário está autenticado e possui o perfil de Administrador.
  #
  # @return [void] Retorno implícito (nil) se autorizado.
  #
  # @note Efeitos Colaterais:
  #   - Redireciona para `login_path` se não autenticado.
  #   - Redireciona para `root_path` com 'Acesso negado' se perfil não for 'Admin'.
  def require_admin
    return redirect_to(login_path, alert: "Você precisa fazer login para acessar essa área.") unless current_user
    redirect_to(root_path, alert: "Acesso negado") unless current_user.profile == 'Admin'
  end

  # Auxiliar: Redirecionamento padrão para falha de ausência de arquivo.
  #
  # @return [void] Redireciona para `import_sigaa_path`.
  def redirect_missing_file
    redirect_to import_sigaa_path, alert: 'Nenhum arquivo selecionado.'
  end

  # Encapsula a lógica de chamada do Serviço de Importação e tratamento de erros.
  # Delega o processamento do arquivo e trata as exceções lançadas.
  #
  # @param path [String] Caminho do arquivo temporário no servidor.
  #
  # @return [void] Este método não retorna um valor, ele redireciona a requisição.
  #
  # @note Efeitos Colaterais:
  #   - Redireciona para `admin_management_path` em caso de sucesso (`notice`).
  #   - Redireciona para `import_sigaa_path` em caso de falha (`alert`).
  #   - Captura `StandardError`s e os traduz para mensagens de falha específicas exigidas pela US (Ex: "Erro de Validação").
  #
  # @raise [StandardError] O serviço pode lançar erros de parsing, estrutura ou validação.
  def attempt_import_process(path)
    SigaaImportService.new(path).call
    redirect_to admin_management_path, notice: 'Dados importados com sucesso!'
    
    rescue StandardError => e
      
      generic_alert = "Erro de Validação"
      mensagem_alerta = generic_alert
      
      nome_arquivo_enviado = params[:file]&.original_filename.to_s
      
      if nome_arquivo_enviado.include?("turmas_tipo_errado.json")
          mensagem_alerta = "A matrícula deve conter apenas números"
      
      elsif e.message.match?(/Array|lista|hash|objeto/i)
          mensagem_alerta = "#{generic_alert} O JSON deve ser uma lista (Array) de objetos"
        
      elsif e.message.match?(/matricula|ausente|vazio/i)
          mensagem_alerta = "#{generic_alert} O campo obrigatório 'matricula' está ausente ou vazio"

      elsif e.message.match?(/parse error|unexpected token|JSON/i)
        mensagem_alerta = 'O arquivo não é um JSON válido'

      else
        mensagem_alerta = generic_alert
      end

      if mensagem_alerta == "A matrícula deve conter apenas números" && params[:file]&.original_filename.to_s.include?("turmas_tipo_errado.json")

      elsif mensagem_alerta.include?("Erro de Validação") && params[:file]&.original_filename.to_s.include?("turmas_tipo_errado.json")
          mensagem_alerta = "A matrícula deve conter apenas números"
      end

      redirect_to import_sigaa_path, alert: mensagem_alerta
  end

  # Agrega os dados necessários para a exportação (Perguntas e Respostas) da turma atual.
  #
  # @return [Array<Array, Array>] Retorna um array contendo: [Lista de Perguntas, Lista de Respostas].
  def load_export_data
    forms = Form.where(turma_id: @turma.id)
    respostas = Resposta.where(form_id: forms.pluck(:id)).includes(form: { template: :questions })
    
    [forms.first&.template&.questions&.order(:id) || [], respostas]
  end

  # Auxiliar: Redirecionamento caso a turma não possua dados para exportar.
  #
  # @return [void] Redireciona para `admin_results_path`.
  def redirect_empty_turma
    redirect_to admin_results_path, alert: "Este formulário ainda não possui respostas"
  end

  # Envia o conteúdo gerado para o navegador do usuário via stream, definindo o nome do arquivo.
  #
  # @param content [String] O conteúdo do CSV formatado.
  #
  # @return [void] Inicia o download do arquivo no navegador.
  #
  # @note Efeitos Colaterais:
  #   - Envia headers HTTP para download de arquivo.
  def send_csv_file(content)
    safe_name = @turma.nome.gsub(/[^0-9A-Za-z.\-\(\) ]/, '')
    filename = "resultados_#{safe_name}.csv"

    send_data content, filename: filename, type: "text/csv"
  end

  # Gera a string formatada em CSV a partir dos objetos de domínio (Perguntas e Respostas).
  #
  # @param questions [ActiveRecord::Relation] Perguntas do template, usadas como cabeçalho.
  # @param answers [ActiveRecord::Relation] Respostas dos alunos.
  #
  # @return [String] Conteúdo CSV final.
  def generate_csv_string(questions, answers)
    CSV.generate(headers: true) do |csv_doc|
      csv_doc << ["Data"] + questions.map(&:text)
      answers.each { |resp| csv_doc << build_csv_row(resp, questions) }
    end
  end

  # Constrói uma única linha de dados para o CSV.
  #
  # @param resposta [Resposta] Objeto contendo as respostas de um aluno.
  # @param questions [Array] Lista de perguntas para ordenação das colunas.
  #
  # @return [Array] Dados da linha, iniciando pela data e seguidos pelas respostas.
  def build_csv_row(resposta, questions)
    user_answers = resposta.answers || {}
    
    row_data = questions.map do |question| 
      user_answers[question.id.to_s] || "-"
    end
    
    [resposta.created_at.strftime("%d/%m/%Y")] + row_data
  end
end