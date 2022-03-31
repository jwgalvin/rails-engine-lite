class Api::V1::SearchesController < ApplicationController
  before_action :filter

  def find_all_items
    item = Item.where("name ILIKE ?", "%#{params[:name]}%")
    render json: ItemSerializer.new(item)
  end

  def find_all_merchants
    merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%")
    render json: MerchantSerializer.new(merchant)
  end

  def find_merchant
    merchant = Merchant.where('name ILIKE ?', "%#{params[:name]}%").first
    if merchant.nil?
      render json: { data: {message: 'No matching merchant'}}, status: 400
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

  def find_item
    item = Item.where('name ILIKE ?', "%#{params[:name]}%").first
    if item.nil?
      render json: { data: {message: 'No matching item'}}, status: 400
    else
      render json: ItemSerializer.new(item)
    end
  end

  #potential refactor, put both find_prices into one method that takes a input from filter to find min or max.
  def find_max_price
    item =  Item.where("items.unit_price <=?", params[:max_price]).order(:name)
    if item.first.class != Item
      render json: {data:{ item: []}}, status: 400
    else
      render json: ItemSerializer.new(item.first)
    end
  end

  def find_min_price
    item =  Item.where("items.unit_price >=?", params[:min_price]).order(:name)
    if item.first.class != Item
      render json: {data:{ item: []}}, status: 400
    else
      render json: ItemSerializer.new(item.first)
    end
  end

  private

  def filter
    if params[:name] && params[:min_price].present?
      price_name
    elsif params[:name] && params[:max_price].present?
      price_name
    elsif params[:min_price].present? && params[:max_price].present?
      price_range
    elsif params[:max_price].present?
      maximum
    elsif params[:min_price].present?
      minimum
    else params.has_key?(:name) || params[:name] == nil
      filter_name
    end
  end
end
