class Response
  attr_accessor :status, :body, :headers

  STATUSES = {
    ok:           200,
    redirect:     301,
    not_found:    404,
    server_error: 500
  }

  def initialize(status = nil, body = '', headers = {})
    self.status   = status
    self.body     = body
    self.headers  = headers
  end

  def redirect(path)
    self.status = STATUSES[:redirect]
    self.headers['Location'] = path
  end

  def error(exception)
    self.status ||= STATUSES[:server_error]
    self.body   ||= { status: "Unable to process request", 
                      error: (exception.nil? ? 'Internal server error' : "#{exception.class} - #{exception.message}")}.to_json
  end
end