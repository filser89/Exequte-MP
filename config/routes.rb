Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users
  root to: 'pages#home'

  resources :training_sessions, only: %i[new create show]
  resources :trainings, only: %i[new create show]
  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      # PAGES
      post 'pages', to: "pages#make_strings"
      # COUPONS
      get 'coupons', to: "coupons#use_coupon"
      # USERS
      resources :users, only: %i[index show update] do
        collection do
          post :wx_login
          get :info
        end
        member do
          get :instructor
          put :wechat_avatar
          post :avatar
        end
      end

      # TRAINING_SESSIONS
      resources :training_sessions, only: [:index, :show] do
        resources :bookings, only: [:create] do
          collection do
            # get :attendance_list
          end
        end
        member do
          put :add_user_to_queue
          get :session_attendance
        end
        collection do
          get :dates_list
          get :instructor_sessions
        end
      end

      # BOOKINGS
      resources :bookings, only: %i[index show] do
        member do
          put :cancel
        end
        collection do
          put :take_attendance
        end
      end

      # MEMBERSHIP_TYPES
      resources :membership_types, only: [:index] do
        resources :memberships, only: [:create]
      end

      resources :banners, only: [:index]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
