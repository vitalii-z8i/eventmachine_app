require 'eventmachine'
require 'em-http-server'

class HTTPHandler < EM::HttpServer::Server

    def process_http_request
      # you have all the http headers in this hash
      puts  @http.inspect
      puts @http_request_uri

      response = EM::DelegatedHttpResponse.new(self)
      response.status = 200
      response.content_type 'text/html'
      response.content = 'It works'
      response.send_response
    end

    def http_request_errback e
      # printing the whole exception
      puts e.inspect
    end

end

EM::run do
    EM::start_server("0.0.0.0", 8081, HTTPHandler)
end