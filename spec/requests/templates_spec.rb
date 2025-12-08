require 'rails_helper'

RSpec.describe "Templates", type: :request do
  let(:admin) { double("Usuario", id: 1, profile: 'Admin') }
  
  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end

  describe "GET /templates (Visualização)" do
    context "Cenário Feliz: Visualizar lista de templates existentes" do
      it "exibe a lista de templates" do
        templates = [double("Template", titulo: "Avaliação A"), double("Template", titulo: "Avaliação B")]
        allow(Template).to receive(:all).and_return(templates)
        allow(templates).to receive(:empty?).and_return(false)

        get templates_path
        
        expect(response).to have_http_status(200)
        expect(response.body).to include("Avaliação A")
      end
    end

    context "Cenário Triste: Visualizar lista vazia" do
      it "exibe mensagem que nenhum template foi criado" do
        allow(Template).to receive(:all).and_return([])
        
        get templates_path
        
        expect(flash[:notice]).to eq("Nenhum template foi criado")
      end
    end
  end

  describe "POST /templates (Criação)" do
    context "Cenário Feliz: Criação com dados válidos" do
      it "cria o template e redireciona" do
        template_params = { titulo: "Avaliação 2024", questions: ["q1", "q2"] }
        template_mock = double("Template", save: true)
        
        allow(Template).to receive(:new).and_return(template_mock)
        allow(template_mock).to receive(:criado_por=)
        allow(template_mock).to receive(:questions=)

        post templates_path, params: { template: template_params }

        expect(flash[:notice]).to eq("Template criado com sucesso")
        expect(response).to redirect_to(templates_path)
      end
    end

    context "Cenário Triste: Tentativa de criação com título vazio" do
      it "não salva e exibe erro" do
        template_mock = double("Template", save: false, errors: double(full_messages: ["O campo Título é obrigatório"]))
        
        allow(Template).to receive(:new).and_return(template_mock)
        allow(template_mock).to receive(:criado_por=)
        allow(template_mock).to receive(:questions=)

        post templates_path, params: { template: { titulo: "" } }

        expect(flash[:alert]).to include("O campo Título é obrigatório")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "Cenário Triste: Tentativa de criação sem questões" do
      it "não salva e exibe erro de questões" do
        template_mock = double("Template", save: false, errors: double(full_messages: ["O template deve conter pelo menos uma questão"]))
        
        allow(Template).to receive(:new).and_return(template_mock)
        allow(template_mock).to receive(:criado_por=)
        allow(template_mock).to receive(:questions=)

        post templates_path, params: { template: { titulo: "Título Válido", questions: [] } }

        expect(flash[:alert]).to include("O template deve conter pelo menos uma questão")
      end
    end
  end

  describe "PUT /templates/:id (Edição)" do
    let(:template_mock) { double("Template", id: 1) }

    before do
      allow(Template).to receive(:find).with("1").and_return(template_mock)
      allow(template_mock).to receive(:questions=)
    end

    context "Cenário Feliz: Edição de nome" do
      it "atualiza o template" do
        expect(template_mock).to receive(:update).with(hash_including("titulo" => "Avaliação A - Revisada")).and_return(true)

        put template_path(1), params: { template: { titulo: "Avaliação A - Revisada" } }

        expect(flash[:notice]).to eq("Template atualizado com sucesso")
        expect(response).to redirect_to(templates_path)
      end
    end

    context "Cenário Triste: Edição com caracteres inválidos" do
      it "não salva e exibe erro" do
        expect(template_mock).to receive(:update).and_return(false)
        allow(template_mock).to receive(:errors).and_return(double(full_messages: ["Formato de título inválido"]))

        put template_path(1), params: { template: { titulo: "Inválido$$$" } }

        expect(flash[:alert]).to eq("Formato de título inválido")
      end
    end
  end

  describe "DELETE /templates/:id (Deleção)" do
    it "Cenário Feliz: remove o template" do
      template_mock = double("Template", id: 1)
      allow(Template).to receive(:find).with("1").and_return(template_mock)
      expect(template_mock).to receive(:destroy)

      delete template_path(1)

      expect(flash[:notice]).to eq("Template removido com sucesso")
      expect(response).to redirect_to(templates_path)
    end
  end
end