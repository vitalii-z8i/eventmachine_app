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
      p 'LALALA'
      param_name = key.scan(/:(.*?)+?(?=\/)/)
      p param_name
      key = key.gsub(/:(.*?)+?(?=\/)/, "(.*)")
      p key
      p request.uri =~ /#{key}/
      result = val if request.uri =~ /#{key}/
    end
    result
  end
end