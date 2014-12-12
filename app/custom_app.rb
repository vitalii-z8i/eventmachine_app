require File.expand_path('core/core.rb')
module CustomApp
  include Core
end

test = CustomApp.routes.build do
  resources :tests
end

p CustomApp.routes.display