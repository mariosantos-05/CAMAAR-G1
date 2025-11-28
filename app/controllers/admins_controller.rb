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
        @turmas = Turma.all
    end

    def export_csv # TEM QUE MUDAR ESSA LÓGICA PARA GERAR O FORMULÁRIO REAL
        @turma = Turma.find(params[:turma_id])
        
        if @turma.vinculos.count == 0
            redirect_to admin_results_path, alert: "Este formulário ainda não possui respostas"
            return
        end

        codigo_materia = @turma.nome.match(/\((.*?)\s-/)&.captures&.first || "TURMA_#{@turma.id}"
        
        filename = "resultados_#{codigo_materia}.csv"

        csv_data = CSV.generate(headers: true) do |csv|
            csv << ["Matricula", "Nome", "Email", "Perfil"]
            
            @turma.vinculos.each do |vinculo|
                u = vinculo.usuario
                csv << [u.matricula, u.nome, u.email, u.profile]
            end
        end

        send_data csv_data, filename: filename, type: 'text/csv'
    end

    private

    def require_admin
        user = try(:current_user) 
        
        if user.present? && user.profile != 'Admin'
            redirect_to admin_management_path, alert: "Acesso negado"
        end
    end
end