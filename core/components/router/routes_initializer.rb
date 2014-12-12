class RoutesInitializer
  attr_accessor :paths
  def initialize &routes
    @paths = {
      get:    [],
      post:   [],
      put:    [],
      delete: []
    }
    self.instance_eval &routes
    p 'lalalalala'
    self
  end

  def resources(name)
    path = name.to_s
    route = "/#{path}"
    get(route, "#{path}#index")
    get("#{route}/:id", "#{path}#show")
    post(route, "#{path}#create")
    put("#{route}/:id", "#{path}#update")
    delete("#{route}/:id", "#{path}#destroy")
  end

  def get(route, path)
    @paths[:get] << {route.to_sym => parse_path(path)}
  end

  def post(route, path)
    @paths[:post] << {route.to_sym => parse_path(path)}
  end

  def put(route, path)
    @paths[:put] << {route.to_sym => parse_path(path)}
  end

  def delete(route, path)
    @paths[:delete] << {route.to_sym => parse_path(path)}
  end

  private
  def parse_path(path)
    controller, action = path.split('#')
    {controller: controller, action: action}
  end
end