require 'rails_helper'

RSpec.describe "AvaliacoesController", type: :request do
  let(:user) { create(:usuario) }

  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return(user)
  end

  describe "GET /avaliacoes" do
    it "lista formulários ativos das turmas do usuário" do
      turma = create(:turma)
      template = create(:template)
      form = create(:form, turma: turma, template: template, is_active: true)

      create(:vinculo, usuario: user, turma: turma)

      get avaliacoes_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(template.titulo)
    end
  end

  describe "GET /avaliacoes/:id/responder" do
    it "bloqueia acesso sem vínculo" do
      turma = create(:turma)
      form = create(:form, turma: turma)

      get responder_form_path(turma.id, form.id)

      expect(response).to redirect_to(avaliacoes_path)
      follow_redirect!
      expect(response.body).to include("Você não tem acesso")
    end
  end

  describe "POST /avaliacoes/:id/enviar_resposta" do
    it "cria resposta válida" do
      turma = create(:turma)
      template = create(:template)
      question = create(:question, template: template)
      form = create(:form, turma: turma, template: template)

      create(:vinculo, usuario: user, turma: turma)

      expect {
        post enviar_resposta_avaliacao_path(form.id), params: {
            answers: { question.id.to_s => "Minha resposta" }
        }
      }.to change(Resposta, :count).by(1)

      expect(response).to redirect_to(avaliacoes_path)
    end
  end
end
