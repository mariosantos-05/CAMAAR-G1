require 'rails_helper'

RSpec.describe "Primeiro Acesso", type: :request do
  # Usuário pendente (status: false) com senha forte e nome
  let!(:user_pendente) { Usuario.create!(nome: 'Novo Aluno', matricula: '12345', email: 'novo@unb.br', password: 'Temp123()', status: false, profile: 'Aluno') }

  # Usuário já ativo (status: true)
  let!(:user_ativo) { Usuario.create!(nome: 'Aluno Ativo', matricula: '67890', email: 'ativo@unb.br', password: 'Pass123()', status: true, profile: 'Aluno') }

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
      # CORREÇÃO CRÍTICA: params: { usuario: ... } em vez de { user: ... }
      patch first_access_path(user_pendente), params: {
        usuario: { password: 'NewPass123!', password_confirmation: 'NewPass123!' }
      }

      user_pendente.reload
      expect(user_pendente.status).to be true
      # Verifica a sessão usando a chave correta do seu controller (:usuario_id)
      expect(session[:usuario_id]).to eq(user_pendente.id)
      expect(response).to redirect_to(avaliacoes_path)
    end

    it "não ativa a conta se as senhas não conferirem" do
      # CORREÇÃO CRÍTICA: params: { usuario: ... }
      patch first_access_path(user_pendente), params: {
        usuario: { password: '123', password_confirmation: '456' }
      }

      # Espera 422 Unprocessable Entity (padrão do Rails moderno para erro de validação)
      expect(response).to have_http_status(:unprocessable_entity)

      user_pendente.reload
      expect(user_pendente.status).to be false
    end
  end
end