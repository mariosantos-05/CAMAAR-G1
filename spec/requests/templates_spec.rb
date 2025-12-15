require 'rails_helper'

RSpec.describe "Templates", type: :request do
  let(:admin) { instance_double(Usuario, id: 1, profile: 'Admin', departamento_id: 1) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end

  describe "GET /admins/templates (Visualização)" do
    context "Cenário Feliz: Visualizar lista de templates existentes" do
      it "exibe a lista de templates" do
        template1 = instance_double(Template, id: 1, titulo: "Avaliação A", target_audience: "Estudantes", questions: [])
        template2 = instance_double(Template, id: 2, titulo: "Avaliação B", target_audience: "Estudantes", questions: [])

        allow(Template).to receive(:all).and_return([template1, template2])

        get admins_templates_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Avaliação A")
        expect(response.body).to include("Avaliação B")
      end
    end
    
  end

  describe "POST /admins/templates (Criação)" do
    let(:template_mock) { 
      instance_double(Template,
        id: nil,
        titulo: nil,
        target_audience: nil,
        questions: [],
        to_model: nil,
        model_name: Template.model_name,
        persisted?: false,
        errors: instance_double(ActiveModel::Errors)
      )
    }

    before do
      allow(template_mock).to receive(:to_model).and_return(template_mock)
      allow(template_mock).to receive(:criado_por=)
      allow(template_mock).to receive(:questions=)
      
      questions_proxy = double("QuestionsProxy") 
      allow(template_mock).to receive(:questions).and_return(questions_proxy)
      allow(questions_proxy).to receive(:build)
      
      allow(Template).to receive(:new).and_return(template_mock)
    end


    context "Cenário Triste: Tentativa de criação com erro" do
      it "não salva e renderiza o form novamente" do
        allow(template_mock).to receive(:save).and_return(false)
        
        erros_mock = template_mock.errors
        allow(erros_mock).to receive(:map).and_return(["O campo Título é obrigatório"])

        post admins_templates_path, params: { template: { titulo: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("form") 
      end
    end
  end

  describe "PUT /admins/templates/:id (Edição)" do
    let(:template_existente) { 
      instance_double(Template,
        id: 1,
        titulo: "Titulo Antigo",
        target_audience: "Docentes",
        questions: [],
        to_model: nil,
        model_name: Template.model_name,
        persisted?: true,
        errors: instance_double(ActiveModel::Errors)
      )
    }

    before do
      allow(template_existente).to receive(:to_model).and_return(template_existente)
      allow(Template).to receive(:find).with("1").and_return(template_existente)
    end


    context "Cenário Triste: Edição inválida" do
      it "não atualiza e mostra erro" do
        allow(template_existente).to receive(:update).and_return(false)
        
        erros_mock = template_existente.errors
        allow(erros_mock).to receive(:map).and_return(["Erro na edição"])

        put admins_template_path(1), params: { template: { titulo: "" } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /admins/templates/:id (Deleção)" do
    it "remove o template" do
        template = instance_double(Template, id: 1)
        allow(Template).to receive(:find).with("1").and_return(template)
        expect(template).to receive(:destroy).and_return(true)
  
        delete admins_template_path(1)
  
        expect(flash[:notice]).to eq("Template removido com sucesso")
        expect(response).to redirect_to(admins_templates_path)
    end
  end
end
