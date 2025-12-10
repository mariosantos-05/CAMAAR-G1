require 'rails_helper'

RSpec.describe "Templates", type: :request do
  let(:admin) { double("Usuario", id: 1, profile: 'Admin') }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end

  describe "GET /admins/templates (Visualização)" do
    context "Cenário Feliz: Visualizar lista de templates existentes" do
      it "exibe a lista de templates" do
        templates = [
          double("Template", id: 1, titulo: "Avaliação A", target_audience: "Estudantes", description: "", questions: []),
          double("Template", id: 2, titulo: "Avaliação B", target_audience: "Estudantes", description: "", questions: [])
        ]

        allow(Template).to receive(:all).and_return(templates)

        get admins_templates_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Avaliação A")
        expect(response.body).to include("Avaliação B")
      end
    end

    context "Cenário Triste: Visualizar lista vazia" do
      it "exibe mensagem que nenhum template foi criado" do
        allow(Template).to receive(:all).and_return([])

        get admins_templates_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Nenhum template foi criado")
      end
    end
  end

  describe "POST /admins/templates (Criação)" do
    context "Cenário Feliz: Criação com dados válidos" do
      it "cria o template e redireciona" do
        template_params = { titulo: "Avaliação 2024", questions: ["q1", "q2"] }
        template_mock = double("Template", save: true)

        allow(Template).to receive(:new).and_return(template_mock)
        allow(template_mock).to receive(:criado_por=)
        allow(template_mock).to receive(:questions=)

        post admins_templates_path, params: { template: template_params }

        expect(flash[:notice]).to eq("Template criado com sucesso")
        expect(response).to redirect_to(admins_templates_path)
      end
    end

    context "Cenário Triste: Tentativa de criação com título vazio" do
      it "não salva e retorna erro" do
        mock_errors = double("Errors")
        allow(mock_errors).to receive(:map).and_return(["O campo Título é obrigatório"])
        allow(mock_errors).to receive(:uniq).and_return(["O campo Título é obrigatório"])
        allow(mock_errors).to receive(:join).with(", ").and_return("O campo Título é obrigatório")

        template_mock = double("Template", save: false, errors: mock_errors)
        allow(Template).to receive(:new).and_return(template_mock)
        allow(template_mock).to receive(:criado_por=)
        allow(template_mock).to receive(:questions=)

        post admins_templates_path, params: { template: { titulo: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "Cenário Triste: Tentativa de criação sem questões" do
      it "não salva e exibe erro de questões" do
        mock_errors = double("Errors")
        allow(mock_errors).to receive(:map).and_return(["O template deve conter pelo menos uma questão"])
        allow(mock_errors).to receive(:uniq).and_return(["O template deve conter pelo menos uma questão"])
        allow(mock_errors).to receive(:join).with(", ").and_return("O template deve conter pelo menos uma questão")

        template_mock = double("Template", save: false, errors: mock_errors)
        allow(Template).to receive(:new).and_return(template_mock)
        allow(template_mock).to receive(:criado_por=)
        allow(template_mock).to receive(:questions=)

        post admins_templates_path, params: { template: { titulo: "Teste", questions: [] } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /admins/templates/:id (Edição)" do
    let(:template_mock) { double("Template", id: 1) }

    before do
      allow(Template).to receive(:find).with("1").and_return(template_mock)
      allow(template_mock).to receive(:questions=)
    end

    context "Cenário Feliz: Edição de nome" do
      it "atualiza o template" do
        expect(template_mock).to receive(:update).with(hash_including("titulo" => "Avaliação A - Revisada")).and_return(true)

        put admins_template_path(1), params: { template: { titulo: "Avaliação A - Revisada" } }

        expect(flash[:notice]).to eq("Template atualizado com sucesso")
        expect(response).to redirect_to(admins_templates_path)
      end
    end

    context "Cenário Triste: Edição com caracteres inválidos" do
      it "não atualiza e mostra erro" do
        mock_errors = double("Errors")
        allow(mock_errors).to receive(:map).and_return(["Formato de título inválido"])
        allow(mock_errors).to receive(:uniq).and_return(["Formato de título inválido"])
        allow(mock_errors).to receive(:join).with(", ").and_return("Formato de título inválido")

        allow(template_mock).to receive(:update).and_return(false)
        allow(template_mock).to receive(:errors).and_return(mock_errors)

        put admins_template_path(1), params: { template: { titulo: "Inválido$$$" } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /admins/templates/:id (Deleção)" do
    it "remove o template" do
      template_mock = double("Template", id: 1)
      allow(Template).to receive(:find).with("1").and_return(template_mock)
      expect(template_mock).to receive(:destroy).and_return(true)

      delete admins_template_path(1)

      expect(flash[:notice]).to eq("Template removido com sucesso")
      expect(response).to redirect_to(admins_templates_path)
    end
  end
end
