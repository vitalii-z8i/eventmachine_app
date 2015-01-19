class Country < Model
  attribute :name
  index :name
  unique :name
  set :cities, :City


  def as_hash
    {id: self.id, name: self.name, cities: self.cities.map(&:as_hash)}
  end
end