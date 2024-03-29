class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item), status: :ok
    else
      render status: 404
    end
  end

  def destroy
    render json: Item.delete(params[:id])
  end


  private
  def item_params
    params.required(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
