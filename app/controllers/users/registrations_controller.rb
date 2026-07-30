class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json

  # Requisicoes com corpo JSON autenticam por credenciais, sem token CSRF.
  # A condicao usa o Content-Type: um formulario cross-site so envia
  # urlencoded/multipart/text-plain, entao o fluxo HTML segue protegido.
  skip_before_action :verify_authenticity_token, if: -> { request.content_mime_type == Mime[:json] }

  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end
end
