 Rails.application.routes.draw do
  get 'users/show'
  devise_for :users
  resources :questions do
    resources :answers, shallow: true do
      member do
        post 'best'
      end
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
