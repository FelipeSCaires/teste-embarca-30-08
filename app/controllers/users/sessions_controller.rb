class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  # Requisicoes JSON autenticam por credenciais, sem token CSRF. A condicao cobre
  # corpo JSON e requisicoes sem corpo negociando JSON (ex.: DELETE do sign_out).
  # Formularios HTML seguem protegidos: um form cross-site sempre envia
  # urlencoded/multipart/text-plain (nunca Content-Type nulo), e fetch cross-site
  # com DELETE/JSON exige preflight CORS, que este app nao responde.
  skip_before_action :verify_authenticity_token,
    if: -> { request.content_mime_type == Mime[:json] || (request.content_mime_type.nil? && request.format.json?) }
end
