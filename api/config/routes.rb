Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [:index, :show] do
        collection do
          post :wx_login
        end
      end
      post 'pages', to: "pages#make_strings"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
