class Home < Controller
  def index
    response.redirect '/countries'
  end

  def search
    country_params = params.select {|k,v| [:name, :id].include?(k)}
    city_params = params.select {|k,v| [:name, :id, :population, :country_id].include?(k)}
    p city_params
    {
      countries: Country.find(country_params).map(&:as_hash),
      cities: City.find(city_params).map(&:as_hash)
    }
  end

  def icon

  end
end