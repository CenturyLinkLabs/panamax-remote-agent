Rails.application.routes.draw do
  resources :deployments, only: [:index, :create, :show, :destroy]
end
