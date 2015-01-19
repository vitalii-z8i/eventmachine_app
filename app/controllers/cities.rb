class Cities < Controller
  def index
    City.all.map(&:as_hash)
  end

  def show
    City.by_id(params[:id]).as_hash
  end

  def destroy
    city = City.by_id(params[:id])
    if city.delete
      {status: 'Record deleted'}
    else
      {status: 'Unable to delete the record'}
    end
  end
end