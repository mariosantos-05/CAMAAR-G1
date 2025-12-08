require 'csv'

class AdminsController < ApplicationController
  before_action :require_admin, except: [:management]

  def management
  end

  def new_import
  end

  def create_import
    uploaded_file = params[:file]

    if uploaded_file.nil?
      redirect_to import_sigaa_path, alert: 'Nenhum arquivo selecionado.'
      return
    end

    begin
      SigaaImportService.new(uploaded_file.path).call
      redirect_to admin_management_path, notice: 'Dados importados com sucesso!'

    rescue JSON::ParserError
      redirect_to import_sigaa_path, alert: 'Erro: O arquivo enviado não é um JSON válido.'
      
    rescue SigaaImportService::InvalidFileError => e
      redirect_to import_sigaa_path, alert: "Erro de Validação: #{e.message}"
      
    rescue StandardError => e
      redirect_to import_sigaa_path, alert: "Ocorreu um erro inesperado: #{e.message}"
    end
  end

  def results
    user = current_user
    admin_dept_id = user&.departamento_id || 1

    prefixo_departamento = case admin_dept_id
                           when 1 then "CIC"
                           when 2 then "MAT"
                           when 3 then "EST"
                           else "CIC"
                           end

    @turmas = Turma.where("nome LIKE ?", "%(#{prefixo_departamento}%")
  end

  def show_respostas
    @turma = Turma.find(params[:turma_id])

    @forms = Form.where(turma_id: @turma.id)

    @respostas = Resposta
                   .where(form_id: @forms.pluck(:id))
                   .includes(:usuario, form: { template: :questions })
  end

  def export_csv
    @turma = Turma.find(params[:turma_id])

    # Recupera os forms e respostas dessa turma
    forms = Form.where(turma_id: @turma.id)
    respostas = Resposta
                  .where(form_id: forms.pluck(:id))
                  .includes(:usuario, form: { template: :questions })

    if respostas.empty?
      redirect_to admin_results_path, alert: "Este formulário ainda não possui respostas"
      return
    end

    # Pega todas as perguntas do template
    perguntas = respostas.first.form.template.questions

    # Código da matéria
    codigo_materia = @turma.nome.match(/\((.*?)\s-/)&.captures&.first || "TURMA_#{@turma.id}"
    filename = "resultados_#{codigo_materia}.csv"

    csv_data = CSV.generate(headers: true) do |csv|
      # Cabeçalho (dinâmico)
      csv << (
        ["Matrícula", "Nome", "Email", "Perfil"] +
        perguntas.map(&:text)
      )

      # Respostas
      respostas.each do |resp|
        user = resp.usuario
        respostas_user = (resp.answers || {})

        csv << (
          [
            user.matricula,
            user.nome,
            user.email,
            user.profile
          ] +
          perguntas.map { |q| respostas_user[q.id.to_s] || "—" }
        )
      end
    end

    send_data csv_data, filename: filename, type: "text/csv"
  end

  private

  def require_admin
    user = try(:current_user)
    
    if user.present? && user.profile != 'Admin'
      redirect_to admin_management_path, alert: "Acesso negado"
    end
  end
end
