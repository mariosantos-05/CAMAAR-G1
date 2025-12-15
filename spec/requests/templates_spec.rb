require 'rails_helper'

RSpec.describe "Templates", type: :request do
  # 1. Mock do Admin (Usuario)
  let(:admin) { instance_double(Usuario, id: 1, profile: 'Admin', departamento_id: 1) }

  # 2. Mock de Erros "Blindado"
  let(:errors_mock) { 
    double("ActiveModel::Errors", 
      any?: false, 
      map: [], 
      full_messages: [], 
      count: 0
    ) 
  }

  # 3. Mock do Template para CRIAÇÃO (Novo)
  let(:template_novo) { 
    instance_double(Template,
      id: nil,
      titulo: nil,
      target_audience: nil,
      questions: [],
      # Métodos para o form_with:
      to_model: nil, 
      model_name: Template.model_name,
      persisted?: false,
      errors: errors_mock
    )
  }

  # 4. Mock do Template para EDIÇÃO (Existente)
  let(:template_existente) { 
    instance_double(Template,
      id: 1,
      titulo: "Titulo Antigo",
      target_audience: "Docentes",
      questions: [],
      to_model: nil,
      model_name: Template.model_name,
      persisted?: true,
      errors: errors_mock
    )
  }

  before do
    # Login do Admin
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    
    # Configuração vital para o form_with funcionar com mocks
    allow(template_novo).to receive(:to_model).and_return(template_novo)
    allow(template_existente).to receive(:to_model).and_return(template_existente)

    # CORREÇÃO DA SINTAXE:
    # Definimos os setters aqui no 'before' em vez de no 'instance_double'
    allow(template_novo).to receive(:criado_por=)
    allow(template_novo).to receive(:questions=)
    
    # Stub para 'questions.build' (chamado no new)
    questions_proxy = double("QuestionsProxy", build: nil)
    allow(template_novo).to receive(:questions).and_return(questions_proxy)
    allow(template_existente).to receive(:questions).and_return(questions_proxy)
  end

  describe "GET /admins/templates (Index)" do
    it "exibe a lista de templates" do
      allow(Template).to receive(:all).and_return([template_existente])
      
      get admins_templates_path
      
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Titulo Antigo")
    end

    it "exibe mensagem de lista vazia" do
      allow(Template).to receive(:all).and_return([])
      get admins_templates_path
      expect(response.body).to include("Nenhum template")
    end
  end

  describe "POST /admins/templates (Create)" do
    before { allow(Template).to receive(:new).and_return(template_novo) }

    context "Cenário Feliz" do
      it "cria o template e redireciona" do
        allow(template_novo).to receive(:save).and_return(true)
        
        post admins_templates_path, params: { template: { titulo: "Novo Template" } }
        
        expect(response).to redirect_to(admins_templates_path)
        expect(flash[:notice]).to include("sucesso")
      end
    end

    context "Cenário Triste" do
      it "não salva e exibe erros no formulário" do
        # Simula falha ao salvar
        allow(template_novo).to receive(:save).and_return(false)
        
        # FORÇA o mock de erros a dizer "Sim, tenho erros"
        allow(errors_mock).to receive(:any?).and_return(true)
        allow(errors_mock).to receive(:map).and_return(["Título obrigatório"])
        
        post admins_templates_path, params: { template: { titulo: "" } }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("form") 
      end
    end
  end

  describe "PUT /admins/templates/:id (Update)" do
    before { allow(Template).to receive(:find).with("1").and_return(template_existente) }

    context "Cenário Feliz" do
      it "atualiza e redireciona" do
        allow(template_existente).to receive(:update).and_return(true)
        
        put admins_template_path(1), params: { template: { titulo: "Editado" } }
        
        expect(response).to redirect_to(admins_templates_path)
        expect(flash[:notice]).to include("sucesso")
      end
    end

    context "Cenário Triste" do
      it "não atualiza e exibe erros" do
        allow(template_existente).to receive(:update).and_return(false)
        
        # FORÇA o mock de erros a dizer "Sim, tenho erros"
        allow(errors_mock).to receive(:any?).and_return(true)
        allow(errors_mock).to receive(:map).and_return(["Erro na edição"])
        
        put admins_template_path(1), params: { template: { titulo: "" } }
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /admins/templates/:id (Destroy)" do
    it "remove o template" do
      allow(Template).to receive(:find).with("1").and_return(template_existente)
      expect(template_existente).to receive(:destroy).and_return(true)
      
      delete admins_template_path(1)
      
      expect(response).to redirect_to(admins_templates_path)
      expect(flash[:notice]).to include("removido")
    end
  end
end