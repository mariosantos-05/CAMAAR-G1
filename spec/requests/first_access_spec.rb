require 'rails_helper'

RSpec.describe "Primeiro Acesso", type: :request do
  # Usuário importado (status: false)
  let!(:user_pendente) { User.create!(matricula: '12345', email: 'novo@unb.br', password: 'Temp123()', status: false, profile: 'Aluno') }

  # Usuário já ativo (status: true)
  let!(:user_ativo) { User.create!(matricula: '67890', email: 'ativo@unb.br', password: 'Pass123()', status: true, profile: 'Aluno') }

  describe "GET /first_access/:id/edit" do
    it "acessa a tela de definir senha se o usuário estiver pendente" do
      get edit_first_access_path(user_pendente)
      expect(response).to have_http_status(200)
    end

    it "redireciona se o usuário já estiver ativo" do
      get edit_first_access_path(user_ativo)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PATCH /first_access/:id" do
    it "ativa a conta com senha válida" do
      patch first_access_path(user_pendente), params: {
        user: { password: 'NewPass123!', password_confirmation: 'NewPass123!' }
      }

      user_pendente.reload
      expect(user_pendente.status).to be true # Verifica se virou Ativo
      expect(session[:user_id]).to eq(user_pendente.id) # Verifica se logou
      expect(response).to redirect_to(avaliacoes_path) # Ajuste a rota se necessário
    end
  end
end
