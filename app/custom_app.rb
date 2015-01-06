require File.expand_path('core/core.rb')
module CustomApp
  COMPONENTS = ['router', 'request']
  include Core
end

p CustomApp.routes.get