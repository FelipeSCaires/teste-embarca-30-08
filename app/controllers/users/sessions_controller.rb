class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  # Requisicoes com corpo JSON autenticam por credenciais, sem token CSRF.
  # A condicao usa o Content-Type: um formulario cross-site so envia
  # urlencoded/multipart/text-plain, entao o fluxo HTML segue protegido.
  skip_before_action :verify_authenticity_token, if: -> { request.content_mime_type == Mime[:json] }
end
