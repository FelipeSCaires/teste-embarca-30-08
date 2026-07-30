class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :json

  # Requisicoes JSON autenticam por credenciais, sem token CSRF. A condicao cobre
  # corpo JSON e requisicoes sem corpo negociando JSON (ex.: DELETE da propria conta).
  # Formularios HTML seguem protegidos: um form cross-site sempre envia
  # urlencoded/multipart/text-plain (nunca Content-Type nulo), e fetch cross-site
  # com DELETE/JSON exige preflight CORS, que este app nao responde.
  skip_before_action :verify_authenticity_token,
    if: -> { request.content_mime_type == Mime[:json] || (request.content_mime_type.nil? && request.format.json?) }

  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end
end
