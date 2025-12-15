require 'rails_helper'

RSpec.describe "Autenticação", type: :request do
  # Cria um usuário para teste
  let!(:user) { User.create!(matricula: '190075384', email: 'wilxavier@me.com', password: 'Pass123()', status: true, profile: 'Aluno') }

  describe "GET /login" do
    it "acessa a página de login com sucesso" do
      get login_path
      expect(response).to have_http_status(200) # Verifica se a tela carrega
    end
  end

  describe "POST /login" do
    it "loga com sucesso e redireciona" do
      post login_path, params: { login: '190075384', password: 'Pass123()' }
      expect(response).to redirect_to(avaliacoes_path) # Verifica se foi pro dashboard
    end

    it "falha com senha errada" do
      post login_path, params: { login: '190075384', password: 'Errada' }
      expect(response).to have_http_status(200) # Fica na mesma página (render :new)
      # Aqui você poderia testar se aparece a mensagem de erro flash, se quiser ser mais detalhista
    end
  end
end
