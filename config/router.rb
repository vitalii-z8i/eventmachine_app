CustomApp.routes.build do
  root 'home#index'
  resources :countries
end