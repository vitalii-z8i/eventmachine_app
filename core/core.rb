module Core

  module ClassMethods
    attr_accessor :request, :router, :controller

    def routes
      self.router ||= Router.new
    end

    def run(params)
      self.request = Request.new(params)
      p self.request.params
      self.router.parse_request(self.request)
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
    receiver.extend ClassMethods
    receiver.load_components
    receiver.load_configs
  end
end