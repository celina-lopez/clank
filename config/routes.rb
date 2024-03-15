Rails.application.routes.draw do
  resources :games, except: %i[destroy edit show] do
    resources :players, only: %i[show]
  end
end
