require File.expand_path('core/components/router/router.rb')
module Core
  module ClassMethods
    def routes
      @router ||= Router.new
    end
  end

  def self.included(receiver)
    receiver.extend ClassMethods
  end
end