class RoutingError < Exception
  def initialize(path)
    super("#{path} was not found on this site")
  end
end

class NoActionError < Exception
  def initialize(action, controller)
    super("There is no #{action} action in #{controller} controller")
  end
end

class NoControllerError < Exception
  def initialize(controller)
    super("There is no controller named #{controller} in this app")
  end
end

class ControllerNotDefinedError < Exception
  def initialize(controller_path)
    super("There is no controller defined in #{controller_path} file")
  end
end

class NoRecordError < Exception
  def initialize(id, class_name)
    super("There is no #{class_name} with id #{id}")
  end
end