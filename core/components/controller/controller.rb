class Controller
  attr_accessor :params, :request, :response

  def initialize(request)
    self.params = request.params
    self.request = request
    self.response = Response.new
    begin
      action_result = self.send(params[:action])
      self.response.body = action_result.to_json
      self.response.status ||= 200
    rescue NoRecordError => e
      self.response.body = {status: "Unable to process request", error: "#{e.class} - #{e.message}"}.to_json
      self.response.status = 404
    end
  end
end
