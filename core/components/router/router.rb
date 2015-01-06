class Router
  Dir["#{File.dirname(__FILE__)}/*.rb"].each {|f| require f}
  def build &routes
    @routes ||= RoutesInitializer.new &routes
    self
  end

  def builded?
    @routes.present?
  end

  def get
    @routes.paths
  end

  def parse_request(request) # Need Request class

  end
end