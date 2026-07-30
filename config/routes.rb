Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # CRUD JSON de usuarios (namespace proprio: POST /users pertence ao Devise)
  namespace :api, defaults: { format: :json } do
    resources :users, except: %i[new edit]
  end

  # Telas HTML de gerenciamento de usuarios (exigem login; destino do redirect pos-login)
  namespace :admin do
    resources :users, except: %i[show]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Documentacao das rotas para o front (arquivo estatico em public/docs/)
  root to: redirect("/docs/rotas-front.html")
end
