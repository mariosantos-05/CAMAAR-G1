class AdminsController < ApplicationController
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
end