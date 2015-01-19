class City < Model
  attribute :name
  index :name
  unique :name
  reference :country, :Country
  attribute :population
  index :population

  def as_hash
    {id: self.id, name: self.name, country_id: self.country_id, population: self.population}
  end
end