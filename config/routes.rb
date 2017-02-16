Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  as :user do
    post 'update_email', to: 'omniauth_callbacks#email', as: :email_from_user
  end

  root to: "questions#index"

  concern :ratable do
    member do
      patch 'rate_up'
      patch 'rate_down'
    end
  end

  resources :answers
  resources :questions, concerns: [:ratable] do
    resources :comments, only: [:new, :create], shallow: true
    resources :answers, shallow: true, concerns: [:ratable] do
      resources :comments, only: [:new, :create], shallow: true
      patch 'mark_best', on: :member
    end
  end
  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end
