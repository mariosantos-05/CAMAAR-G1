require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
  let(:admin) { create(:admin) }
  let(:aluno) { create(:usuario, profile: 'Aluno') }

  let(:turma) { create(:turma, nome: "Turma Teste (CIC - 2025)") }
  let(:turma_vazia) { create(:turma) }

  let(:template) { create(:template, criado_por: admin) }
  let(:question) { template.questions.first }
  let!(:form) { create(:form, turma: turma, template: template) }

  let!(:resposta) {
    create(:resposta, form: form, usuario: aluno, answers: { question.id.to_s => "Resposta X" })
  }

  context "quando não há usuário logado" do
    before do
      allow(controller).to receive(:current_user).and_return(nil)
    end

    it "redireciona para login ao tentar acessar management" do
      get :management
      expect(response).to redirect_to(login_path)
      expect(flash[:alert]).to include("Você precisa fazer login")
    end
  end

  context "quando logado como Aluno" do
    before do
      allow(controller).to receive(:current_user).and_return(aluno)
    end

    it "redireciona management para a home" do
      get :management
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include("Acesso negado")
    end

    it "redireciona exportação para a home" do
      get :export_csv, params: { turma_id: turma.id }
      expect(response).to redirect_to(root_path)
    end
  end

  context "quando logado como Admin" do
    before do
      allow(controller).to receive(:current_user).and_return(admin)
    end

    describe "GET #management" do
      it "acessa com sucesso (200)" do
        get :management
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET #new_import" do
      it "acessa a tela de upload com sucesso" do
        get :new_import
        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET #results" do
      it "carrega as turmas" do
        get :results
        expect(response).to have_http_status(:ok)
        expect(assigns(:turmas)).to include(turma)
      end
    end

    describe "GET #show_respostas" do
      it "exibe as respostas da turma corretamente" do
        get :show_respostas, params: { turma_id: turma.id }

        expect(response).to have_http_status(:ok)
        expect(assigns(:respostas)).to include(resposta)
      end
    end

    describe "GET #export_csv" do
      it "baixa o CSV se houver respostas" do
        get :export_csv, params: { turma_id: turma.id }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('text/csv')
        expect(response.body).to include("Resposta X")
      end

      it "redireciona se a turma estiver vazia" do
        get :export_csv, params: { turma_id: turma_vazia.id }
        expect(response).to redirect_to(admin_results_path)
        expect(flash[:alert]).to include("não possui respostas")
      end
    end

    describe "POST #create_import" do
      let(:fake_file) { fixture_file_upload('spec/fixtures/files/dados.json', 'application/json') }
      let(:service_mock) { instance_double("SigaaImportService") }

      before do
        FileUtils.mkdir_p('spec/fixtures/files')
        File.write('spec/fixtures/files/dados.json', '{}')
        allow(SigaaImportService).to receive(:new).and_return(service_mock)
      end

      context "quando ocorre erro na importação" do
        it "redireciona com erro quando o JSON é inválido" do
          allow(service_mock).to receive(:call).and_raise(JSON::ParserError)
          post :create_import, params: { file: fake_file }

          expect(response).to redirect_to(import_sigaa_path)
          # expect(flash[:alert]).to include("Erro de Validação")
          expect(flash[:alert]).to include("O arquivo não é um JSON válido")
        end

        it "redireciona com erro genérico" do
          allow(service_mock).to receive(:call).and_raise(StandardError.new("Falha de conexão"))
          post :create_import, params: { file: fake_file }

          expect(response).to redirect_to(import_sigaa_path)
          # expect(flash[:alert]).to include("Ocorreu um erro inesperado")
          expect(flash[:alert]).to include("Erro de Validação")
        end

        it "reclama se não enviar arquivo" do
          post :create_import, params: {}
          expect(flash[:alert]).to include("Nenhum arquivo")
        end
      end

      context "quando a importação funciona" do
        before do
          allow(service_mock).to receive(:call).and_return(true)
        end

        it "redireciona com sucesso" do
          post :create_import, params: { file: fake_file }
          expect(response).to redirect_to(admin_management_path)
          expect(flash[:notice]).to include("sucesso")
        end
      end
    end
  end
end
