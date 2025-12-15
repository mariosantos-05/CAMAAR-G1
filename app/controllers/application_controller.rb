class ApplicationController < ActionController::Base
  # Configuração padrão do Rails 8 (mantenha)
  allow_browser versions: :modern

  # Disponibiliza estes métodos para serem usados nas Views (ex: no navbar)
  helper_method :current_user, :logged_in?, :admin?

  # Retorna o usuário logado buscando pela sessão
  def current_user
    # Se já carregou, usa a variável de instância.
    # Se não, busca no banco usando o ID salvo no cookie de sessão.
    @current_user ||= Usuario.find_by(id: session[:usuario_id]) if session[:usuario_id]
  end

  # Retorna true se existe alguém logado
  def logged_in?
    !!current_user
  end

  # Retorna true se o usuário logado é Admin
  def admin?
    logged_in? && current_user.profile == "Admin"
  end

  # Filtro de segurança para usar com 'before_action' nos controllers de Admin
  def require_admin
    unless admin?
      flash[:alert] = "Acesso negado. Apenas administradores."

      if logged_in?
        # Se é aluno tentando acessar área admin, manda pro dashboard de aluno
        redirect_to avaliacoes_path
      else
        # Se não tá logado, manda pro login
        redirect_to root_path
      end
    end
  end
end
