CustomApp.routes.build do
  root 'home#index'
  get '/search', 'home#search'
  get '/favicon.ico', 'home#icon'
  resources :countries
  resources :cities
end