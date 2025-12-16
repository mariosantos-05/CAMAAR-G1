require 'rails_helper'

RSpec.describe "Autenticação", type: :request do
  # Cria um usuário com senha FORTE para passar na validação do Model
  let!(:user) { Usuario.create!(nome: 'Aluno Teste', matricula: '190075384', email: 'wilxavier@me.com', password: 'Pass123()', status: true, profile: 'Aluno') }

  describe "GET /login" do
    it "acessa a página de login com sucesso" do
      get login_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /login" do
    it "loga com sucesso e redireciona" do
      post login_path, params: { login: '190075384', password: 'Pass123()' }
      expect(response).to redirect_to(avaliacoes_path)
    end

    it "falha com senha errada" do
      post login_path, params: { login: '190075384', password: 'Errada' }
      expect(response).to have_http_status(200)
    end

    it "redireciona para primeiro acesso se senha for nil" do
      # 1. Cria usuário válido com senha forte
      user_sem_senha = Usuario.create!(nome: 'Sem Senha', matricula: '000000', email: 'n@n.com', password: 'Pass123()', status: true, profile: 'Aluno')

      # 2. Força a senha a ser nil direto no banco (pula validações)
      user_sem_senha.update_column(:password_digest, nil)

      post login_path, params: { login: '000000', password: 'any' }

      # Agora deve redirecionar corretamente
      expect(response).to redirect_to(edit_first_access_path(user_sem_senha))
    end

    it "exibe erro se usuário não existe" do
      post login_path, params: { login: 'inexistente', password: '123' }
      expect(flash[:alert]).to eq("E-mail ou matrícula não encontrados")
    end
  end
end