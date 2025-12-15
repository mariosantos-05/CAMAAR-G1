require 'rails_helper'

RSpec.describe "Admins::FormsController", type: :request do
  let(:admin) { create(:usuario, profile: "Admin") }

  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return(admin)
  end

  describe "GET /admins/forms/new" do
    it "carrega templates e turmas ativas" do
      template = create(:template)
      turma = create(:turma, is_active: true)

      get new_admins_form_path

      expect(response).to have_http_status(:ok)
      expect(assigns(:templates)).to include(template)
      expect(assigns(:turmas)).to include(turma)
    end
  end

  describe "POST /admins/forms" do
    let(:template) { create(:template) }
    let(:turma) { create(:turma, is_active: true) }

    it "não cria formulário se faltar dados" do
      expect {
        post admins_forms_path, params: { template_id: nil, turma_ids: [] }
      }.not_to change(Form, :count)

      expect(response).to redirect_to(admin_management_path)
      follow_redirect!
      expect(response.body).to include("Selecione um template")
    end

    it "cria formulários para as turmas selecionadas" do
      expect {
        post admins_forms_path, params: {
          template_id: template.id,
          turma_ids: [turma.id]
        }
      }.to change(Form, :count).by(1)

      expect(response).to redirect_to(admin_management_path)
    end
  end
end
