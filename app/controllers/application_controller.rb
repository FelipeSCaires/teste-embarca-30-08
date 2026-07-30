class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern, unless: -> { request.format.json? }

  private

  # Sessao valida (login ou cadastro) redireciona para a tela de gerenciamento de usuarios.
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || admin_users_path
  end

  def after_sign_out_path_for(_scope)
    new_user_session_path
  end
end
