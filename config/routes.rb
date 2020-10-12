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
  resources :links, only: [:destroy]
  resources :users, only: [:show]
  root to: 'questions#index'
end
