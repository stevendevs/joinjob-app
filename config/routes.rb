Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  resources :courses do 
    resources :lessons
  end

  resources :users, only: [:index, :edit, :show, :update]
  
  resources :lessons # <- agregando esto también habilita /lessons
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # Agrega esta línea
  get "explore", to: "explore#show", as: :explore
  get "activity", to: "home#activity", as: :home_activity
  # Defines the root path route ("/")
   root "home#index"
end
