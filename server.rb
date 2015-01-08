require 'eventmachine'
require 'em-http-server'
require 'json'
require File.expand_path('app/custom_app.rb')
class HTTPHandler < EM::HttpServer::Server

  def process_http_request
    request_params = {
      method: @http_request_method,
      uri:    @http_request_uri,
      params: [@http_query_string, @http_content]
    }

    request = CustomApp.run(request_params)

    respond('It works', 'text/json')

  rescue Exception => e
    Logger.error("#{e.class} - #{e.message}")
    e.backtrace.each do |line| 
      print(line)
      print("\n")
    end
    respond({error: "Unable to process request"}.to_json, 'text/html')
  end

  def respond(body = '', content = 'text/json')
    response = EM::DelegatedHttpResponse.new(self)
    response.status = 200
    response.content_type content
    response.content = body
    response.send_response
  end
end

EM::run do
  EM::start_server("0.0.0.0", 8081, HTTPHandler)
end