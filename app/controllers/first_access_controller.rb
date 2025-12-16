class FirstAccessController < ApplicationController
  # Exibe o formulário para definição de senha no primeiro acesso.
  #
  # Argumentos:
  #   - params[:id] (Integer): ID do usuário.
  #
  # Retorno:
  #   - Renderiza a view 'edit'.
  #   - Ou redireciona para root_path se o usuário já estiver ativo.
  #
  # Efeitos Colaterais: Consulta o banco de dados.
  def edit
    @user = Usuario.find(params[:id])

    # RN-DS-01 (Indireto): Se o usuário já estiver ativo, o link "expira"
    if @user.status == true
      redirect_to root_path, alert: "Sua conta já foi ativada. Faça login."
    end
  end

  # Atualiza a senha e ativa a conta do usuário.
  #
  # Argumentos:
  #   - params[:id] (Integer): ID do usuário.
  #   - params[:usuario] (Hash): Contém password e password_confirmation.
  #
  # Retorno:
  #   - Redireciona para 'avaliacoes_path' em caso de sucesso.
  #   - Renderiza 'edit' com status 422 em caso de erro.
  #
  # Efeitos Colaterais:
  #   - Atualiza o registro do usuário no banco (senha e status).
  #   - Inicia a sessão (login automático).
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

  # Filtra os parâmetros permitidos para atualização.
  def user_params
    params.require(:usuario).permit(:password, :password_confirmation)
  end
end