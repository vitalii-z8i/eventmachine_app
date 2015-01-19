module Core
  COMPONENTS = ['router', 'request', 'logger', 'exceptions', 'controller', 'model', 'response']
  module ClassMethods
    attr_accessor :request, :router, :controller

    def routes
      self.router ||= Router.new
    end

    def process_request(params)
      self.request = Request.new(params)
      self.request = self.router.parse_request(self.request)
      Logger.info("[REQUEST][#{self.request.method}] #{self.request.uri} \n [PARAMS] #{self.request.params}")
      unless self.request.valid
        raise RoutingError.new("[#{self.request.method}] #{self.request.uri}")
      end

      self.request.process
    end

    def load_components
      self::COMPONENTS.each do |component|
        p "#{component} component loaded" if require "#{File.dirname(__FILE__)}/components/#{component}/#{component}.rb"
      end
    end

    # PATH app_root/config/{component}.rb
    def load_configs
      self::COMPONENTS.each do |config|
        require File.expand_path("config/#{config}.rb") if File.file?(File.expand_path("config/#{config}.rb"))
      end
    end
  end

  def self.included(receiver)
    receiver::COMPONENTS.unshift(*self::COMPONENTS)
    receiver.extend ClassMethods
    receiver.load_components
    receiver.load_configs
  end
end