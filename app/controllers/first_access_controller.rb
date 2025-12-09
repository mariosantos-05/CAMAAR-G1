class FirstAccessController < ApplicationController
  # GET /first_access/:id/edit
  def edit
    @user = Usuario.find(params[:id])

    # RN-DS-01 (Indireto): Se o usuário já estiver ativo, o link "expira"
    if @user.status == true
      redirect_to root_path, alert: "Sua conta já foi ativada. Faça login."
    end
  end

  # PATCH /first_access/:id
  def update
    @user = Usuario.find(params[:id])

    # Verifica se as senhas batem e se atendem aos requisitos (RN-DS-02, RN-DS-03)
    # E muda o status para true (RN-DS-04)
    if @user.update(user_params.merge(status: true))
      # Loga o usuário automaticamente após definir a senha
      session[:usuario_id] = @user.id
      redirect_to avaliacoes_path, notice: "Senha definida com sucesso! Bem-vindo."
    else
      # Se der erro (senha fraca ou não coincidir), volta para a tela de edição
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:usuario).permit(:password, :password_confirmation)
  end
end