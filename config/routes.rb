 Rails.application.routes.draw do
  use_doorkeeper
  get 'users/show'
  get '/users/email_get', to: 'users#email_get', as: 'users_email_get'
  post '/users/email_post', to: 'users#email_post', as: 'users_email_post'
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  resources :questions do
    resources :answers, shallow: true do
      member do
        post 'best'
      end
    end
  end
  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end
			resources :questions, only: [:index, :show, :create, :update, :destroy] do
				resources :answers, shallow: true
			end
      resources :users, only: [:index]
    end
  end
  resources :attachments, only: [:destroy]
  resources :comments, only: [:create]
  resources :links, only: [:destroy]
  resources :users, only: [:show]
  root to: 'questions#index'
  post '/votes/votes_down', to: 'votes#votes_down', as: 'votes_down'
  post '/votes/votes_up', to: 'votes#votes_up', as: 'votes_up'
  post '/votes/votes_cancel', to: 'votes#votes_cancel', as: 'votes_cancel'
  mount ActionCable.server => '/cable'
end
