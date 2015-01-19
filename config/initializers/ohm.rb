Ohm.redis = Redic.new('redis://127.0.0.1:6379/1')

Dir["#{File.dirname(__FILE__)}/../../app/models/*.rb"].each {|f| require f}