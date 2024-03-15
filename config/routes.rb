# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  resources :games, except: %i[destroy edit show] do
    resources :players, only: %i[show]
  end
end
