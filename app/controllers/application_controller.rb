class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  def current_user
    nil # Ninguém está logado
  end

  helper_method :current_user

  allow_browser versions: :modern
end
