class SessionsController < ApplicationController
  # ADICIONE ESTA LINHA: Define que este controller usa o layout isolado
  layout "auth"

  def new
  end

  def create
    # RN-L-01: Autenticar por email OU matrícula
    login = params[:login]
    user = Usuario.find_by(email: login) || Usuario.find_by(matricula: login)

    # RN-L-06: Só permite login se status for true (Ativo)
    if user
      # 1. Sem senha definida (senha é nil)
      if user.password_digest.nil?
        redirect_to edit_first_access_path(user), notice: "Bem-vindo! Por favor, defina sua senha para continuar."
        return
      end

      # 2. Conta inativa (status é false)
      if user.status == false
        redirect_to edit_first_access_path(user), alert: "Sua conta ainda não foi ativada."
        return
      end
      # 3. Tentativa de Login
      if user.authenticate(params[:password])
        session[:usuario_id] = user.id
        redirect_to destination_by_profile(user)
      else
        flash.now[:alert] = "Senha incorreta"
        render :new
      end
    else
      # Usuário não encontrado
      flash.now[:alert] = "E-mail ou matrícula não encontrados"
      render :new
    end
  end

  def destroy
    session[:usuario_id] = nil
    redirect_to root_path, notice: "Logout realizado com sucesso"
  end

  private

  def destination_by_profile(user)
    # RN-L-04 e RN-L-05
    user.profile == "Admin" ? admin_management_path : avaliacoes_path
  end
end
