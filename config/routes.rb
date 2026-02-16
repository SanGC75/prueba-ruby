Rails.application.routes.draw do
  root to: "api/v1/authentication#new"
  namespace :api do
    namespace :v1 do
      get "/login", to: "authentication#new", as: :auth_login
      post "auth/login", to: "authentication#login"
      get "auth/logout", to: "authentication#logout", as: :auth_logout
      resources :customers, only: [ :index, :show, :update, :create, :destroy, :edit, :new ] do
        member do
          patch :restore
        end
      end
    end
  end
end
