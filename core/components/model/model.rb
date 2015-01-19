require "ohm"
class Model < Ohm::Model
  def self.by_id(id)
    self[id] || (raise NoRecordError.new(id, self.name))
  end
end