Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true do
      member do
        get 'best'
      end
    end
  end
  root to: 'questions#index'
  
end
