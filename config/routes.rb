Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
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
