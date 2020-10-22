Rails.application.routes.draw do
  # get 'votes/create'
  # get 'votes/destroy'
  get 'users/show'
  devise_for :users
  resources :questions do
    # resources :votes, shallow: true#, only: [:create, :delete]
    resources :answers, shallow: true do
      # resources :votes, shallow: true#, only: [:create, :delete]
      member do
        post 'best'
      end
    end
  end
  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :users, only: [:show]
  root to: 'questions#index'
  # resources :votes do
  #   member do
  #     post 'votes_up'
  #     post 'votes_down'
  #   votes_down  post 'votes_cancel'
  #   end
  # end
  post '/votes/votes_down', to: 'votes#votes_down', as: 'votes_down'
  post '/votes/votes_up', to: 'votes#votes_up', as: 'votes_up'
  post '/votes/votes_cancel', to: 'votes#votes_cancel', as: 'votes_cancel'
end
