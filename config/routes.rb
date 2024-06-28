# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'pages#index'
  resources :games, except: %i[destroy edit update] do
    resources :players, only: %i[show]
  end
end
