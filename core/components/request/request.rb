class Request
  Dir["#{File.dirname(__FILE__)}/*.rb"].each {|f| require f}
  attr_accessor :uri, :method, :params

  def initialize(request = '')
    self.method = request[:method]
    self.uri = request[:uri] || '/'
    self.params = parse_params(request[:params])
    Logger.info("[REQUEST][#{self.method}] #{self.uri} \n [PARAMS] #{self.params}")
  end


  private
  def parse_params(params)
    query_string, form_data = params

    parse_query_string(query_string).merge(parse_form_data(form_data))
  end

  def parse_query_string(query_string = nil)
    unless query_string.nil?
      query_string.split('&').map do |var|
        var = var.split('=')
        {var[0].to_sym => var[1]}
      end.inject(&:merge)
    else
      {}
    end
  end

  def parse_form_data(form_data = nil)
    unless form_data.nil?
      keys = form_data.scan(/name=["'](.*)["']/).map(&:first).map(&:to_sym)
      vals = form_data.scan(/(.*)\n-/).map {|str| str[0].gsub("\r", '')}
      Hash[keys.zip(vals)]
    else
      {}
    end
  end
end