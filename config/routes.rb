# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'pages#index'
  resources :games, only: %i[create new]
  resource :instructions, only: [] do
    get :clank
  end
  resources :games, only: %i[show]

  get '/:game_type/games/:game_id/players/:player_id', to: 'players#show', as: :game_player
end
