class SessionsController < ApplicationController

  # ADICIONE ESTA LINHA: Define que este controller usa o layout isolado
  layout 'auth'

  def new
  end

  def create
    # RN-L-01: Autenticar por email OU matrícula
    login = params[:login]
    user = User.find_by(email: login) || User.find_by(matricula: login)

    # RN-L-06: Só permite login se status for true (Ativo)
    if user && user.authenticate(params[:password])
      if user.status == true
        session[:user_id] = user.id
        redirect_to destination_by_profile(user)
      else
        flash.now[:alert] = "Sua conta ainda está pendente. Verifique seu email."
        render :new
      end
    else
      # RN-L-03: Mensagem genérica
      flash.now[:alert] = "Email/Matrícula ou senha inválidos"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logout realizado com sucesso"
  end

  private

  def destination_by_profile(user)
    # RN-L-04 e RN-L-05
    user.profile == 'Admin' ? admin_dashboard_path : user_dashboard_path
  end
end