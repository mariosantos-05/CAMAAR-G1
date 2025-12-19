# Gerencia o ciclo de vida da sessão (login, logout e autenticação).
# Permite que usuários entrem no sistema via matrícula ou email.
class SessionsController < ApplicationController
  # Define que este controller usa o layout isolado para autenticação
  layout "auth"

  # Renderiza a tela de login.
  #
  # Argumentos: Nenhum.
  # Retorno: Renderiza a view 'new'.
  # Efeitos Colaterais: Nenhum.
  def new
  end

  # Processa a tentativa de login do usuário.
  # Refatorado para reduzir complexidade ciclomática e eliminar duplicação.
  #
  # Argumentos:
  #   - params[:login] (String): Email ou Matrícula.
  #   - params[:password] (String): Senha do usuário.
  def create
    login = params[:login]
    user = Usuario.find_by(email: login) || Usuario.find_by(matricula: login)

    # 1. Usuário não encontrado
    return handle_login_error("E-mail ou matrícula não encontrados") unless user

    # 2. Verificações de acesso (Sem senha ou Inativo)
    return if check_account_status(user)

    # 3. Senha incorreta
    return handle_login_error("Senha incorreta") unless user.authenticate(params[:password])

    # 4. Sucesso
    perform_login(user)
  end

  # Realiza o logout do usuário.
  def destroy
    session[:usuario_id] = nil
    redirect_to root_path, notice: "Logout realizado com sucesso"
  end

  private

  # Centraliza a lógica de erro de login para evitar DuplicateMethodCall
  def handle_login_error(message)
    flash.now[:alert] = message
    render :new
  end

  # Verifica status da conta e redireciona se necessário.
  # Retorna true se houve redirecionamento (interrompendo o login), false caso contrário.
  def check_account_status(user)
    if user.password_digest.nil?
      redirect_to edit_first_access_path(user), notice: "Bem-vindo! Por favor, defina sua senha para continuar."
      return true
    end

    if user.status == false
      redirect_to edit_first_access_path(user), alert: "Sua conta ainda não foi ativada."
      return true
    end

    false
  end

  # Executa a lógica de sucesso do login
  def perform_login(user)
    session[:usuario_id] = user.id
    redirect_to destination_by_profile(user)
  end

  def destination_by_profile(user)
    user.profile == "Admin" ? admin_management_path : avaliacoes_path
  end
end
