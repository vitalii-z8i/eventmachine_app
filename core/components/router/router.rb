require File.expand_path('core/components/router/routes_initializer.rb')
class Router

  def build &routes
    @routes ||= RoutesInitializer.new &routes
    self
  end

  def display
    @routes.paths
  end

  def parse_request(request) # Need Request class

  end
end