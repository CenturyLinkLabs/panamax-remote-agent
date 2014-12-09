Rails.application.routes.draw do
  resources :deployments, only: [:index, :create, :show, :destroy] do
    member do
      post :redeploy
    end
  end

  resource :metadata, only: :show
end
