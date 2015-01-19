require 'eventmachine'
require 'em-http-server'
require 'json'
require File.expand_path('app/custom_app.rb')
require File.expand_path('config/initializers/ohm.rb')

class HTTPHandler < EM::HttpServer::Server

  def process_http_request
    request_params = {
      method: @http_request_method,
      uri:    @http_request_uri,
      params: [@http_query_string, @http_content]
    }

    response = CustomApp.process_request(request_params)

    respond((response.status || 200), response.body, 'text/json', (response.headers || {}))
  rescue Exception => e
    Logger.error("#{e.class} - #{e.message}")
    e.backtrace.each do |line| 
      print(line)
      print("\n")
    end
    respond(500, {status: "Unable to process request", error: "#{e.class} - #{e.message}"}.to_json, 'text/json')
  end

  def respond(status = 200, body = '', content = 'text/json', headers = {})
    response = EM::DelegatedHttpResponse.new(self)
    response.status = status
    response.content_type content
    response.content = body
    headers.each do |header, value|
      response.headers[header] = value
    end
    response.send_response
    Logger.info("[COMPLETED][#{response.status}]")
  end
end

EM::run do
  EM::start_server("0.0.0.0", 8081, HTTPHandler)
end