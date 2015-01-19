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

  def parse_request(request)
    result = {}
    @routes.paths.send(:[], request.method.downcase.to_sym).each do |key, val|
      param_names = []
      param_values = []
      param_names = key.scan(/:(.*?(?=\/|$))/).inject(&:concat) || []
      key = key.gsub(/:(.*?(?=\/|$))/, "(.*)")
      if request.uri =~ /^#{key}$/
        result = val
        param_values = request.uri.scan(/^#{key}$/).inject(&:concat) if param_names.any?
        request.params.merge!(result)
        request.params.merge!(Hash[param_names.map(&:to_sym).zip(param_values)])
        request.valid = true
      end
    end
    request
  end
end