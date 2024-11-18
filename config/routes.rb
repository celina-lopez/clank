# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'pages#index'
  resources :games, only: %i[create new]
  resource :instructions, only: [] do
    get :clank
  end
  %w[clank aeons_end].each do |game|
    namespace game do
      resources :games, only: %i[show] do
        resources :players, only: %i[show]
      end
    end
  end
end
