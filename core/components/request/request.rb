class Request
  Dir["#{File.dirname(__FILE__)}/*.rb"].each {|f| require f}
  attr_accessor :uri, :method, :params

  def initialize(request = '', path = '')
    self.method = request[:method]
    self.uri = path
    self.params = self.parse_params(request[:params])
  end

  def parse_params(params)
    query_string, form_data = params

    parse_query_string(query_string).concat(parse_form_data).inject(&:merge)
  end

  def parse_query_string(query_string = '')
    query_string.split('&').map do |var|
      var = var.split('=')
      {var[0] => var[1]}
    end
  end

  def parse_form_data(form_data = '')
    []
  end
end