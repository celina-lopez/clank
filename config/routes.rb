Rails.application.routes.draw do
  resources :games, except: %i[destroy edit]
end
