require 'eventmachine'

module WorkersServer
  def post_init
    p "Worker connected"
  end

  # data = {command: 'connect', worker_id: 1}
  def receive_data data
    data = JSON.parse(data)
    p "[INFO] A message from Worker, data: #{data}"
    # TcpCommands.send(data['command'].to_sym, data)
    send_data 'all_ok'
  rescue => e
    case e
    # when ActiveRecord::RecordNotFound
    #   p '[ERROR] Unregistered worker'
    when JSON::ParserError
      p '[ERROR] Wrong data format (Must be a valid JSON)'
      p "[DEBUG] #{data} given"
    when NoMethodError
      p '[ERROR] Wrong command was sent'
    else
      p "[ERROR] Unhandled server error (#{e.class} #{e.message})"
    end
    send_data 'disconnected'
    close_connection_after_writing
  end

  def unbind
    p "Worker disconnected"
  end

  # require ::File.expand_path('lib/tcp_commands')
end

EventMachine.run {
  EventMachine.start_server '', 8081, WorkersServer
  EventMachine.add_periodic_timer(60) {
    Worker.request_workers_statuses
    p 'Workers statuses updated'
  }
}