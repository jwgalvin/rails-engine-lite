class Api::V1::ItemMerchantsController < ApplicationController
  def index
     if Item.exists?(params[:item_id])
      item = Item.find(params[:item_id])
      #binding.pry
      render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
     else
      render json: {errors: { details: "error"}}
    end
  end
 end
