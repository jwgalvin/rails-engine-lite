class ApplicationController < ActionController::API
  def maximum
    if params[:max_price] == nil
      render json:JSON.generate({ error:{details: 'No price.'}}), status: 400
    elsif params[:max_price].to_f <= 0.0
      render json:JSON.generate({ error:{details: 'Price cannot be negative.'}}), status: 400
    else
      find_max_price
    end
  end

  def minimum
    if params[:min_price] == nil
      render json:JSON.generate({ error:{errors: 'No price.'}}), status: 400
    elsif params[:min_price].to_f <= 0.0
      render json:JSON.generate({ error:{errors: 'Price cannot be negative.'}}), status: 400
      #binding.pry
    else
      find_min_price
    end
  end


  def price_name
    render json: JSON.generate({ errors:{details: 'Too many params.'}}), status: 400
  end

  def price_range
    if params[:max_price].to_f < params[:min_price].to_f
      render json: JSON.generate({ errors:{details: 'Min price cannot be less than max price.'}}), status: 400
      else
    end
  end

  def filter_name
    if params[:name] == nil
      render json: JSON.generate({errors: {details: 'no params.'}}), status:400
    elsif params[:name] == ""
      render json: JSON.generate({errors: {details: 'empty params.'}}), status:400
    end
  end
end
