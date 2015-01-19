class Countries < Controller

  def index
    Country.all.map(&:as_hash)
  end

  def show
    Country.by_id(params[:id]).as_hash
  end

  def create
    params[:cities] = params[:country][:cities] || []
    country = Country.new(params[:country].reject{|key, val| key == :cities})
    if country.save
      params[:cities].map {|c| c.merge(country_id: country.id) }.each do |city|
        country.cities.add(City.create(city))
      end
      {status: 'Record created'}
    else
      {status: 'Unable to save the record', country: country.to_json}
    end
  end

  def update
    params[:cities] = params[:country][:cities] || []
    country = Country.by_id(params[:id])
    (params[:country].reject{|key, val| key == :cities}).each do |field, value|
      country.send("#{field}=", value)
    end
    if country.save
      params[:cities].each do |city_params|
        if city_params[:id].nil?
          City.create(city_params.merge(country_id: country.id))
        else
          city = City.by_id(city_params[:id])
          city.name = city_params[:name] unless city_params[:name].nil?
          city.country_id = city_params[:country_id] unless city_params[:country_id].nil?
          city.population = city_params[:population] unless city_params[:population].nil?
          city.save
        end
      end
      {status: 'Record saved'}
    else
      {status: 'Unable to save the record', country: country.to_json}
    end
  end

  def destroy
    country = Country.by_id(params[:id])
    if !country.nil? && country.delete
      City.find(country_id: params[:id]).map(&:delete)
      {status: 'Record deleted'}
    else
      {status: 'Unable to delete the record'}
    end
  end
end