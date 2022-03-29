require 'rails_helper'

describe "Merchants API" do
  it "sad paths a blank parse" do
    get '/api/v1/merchants'

    expect(response).to be_successful
    merchant_list = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_list[:data].count).to eq(0)
  end

  it "response grabs are the merchants" do
    create_list(:merchant, 10)
    get '/api/v1/merchants'

    expect(response).to be_successful
    merchant_list = JSON.parse(response.body, symbolize_names: true)

    expect(merchant_list[:data].count).to eq(10)
  end

  it "Verifies that all merchants have all the attributes" do
    create_list(:merchant, 10)
    get '/api/v1/merchants'

    expect(response).to be_successful
    merchant_list = JSON.parse(response.body, symbolize_names: true)
    merchant_list[:data].each do |merchant|
      #binding.pry
      expect(merchant[:id]).to be_a(String)
      expect(merchant[:type]).to eq("merchant")
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
  it "only get 1 merchant" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    get "/api/v1/merchants/#{merchant1.id}"

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)
    #.pry
    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data][:type]).to eq("merchant")
    expect(merchant[:data][:attributes][:name]).to be_a(String)
    expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
  end

  it "returns the item's merchant id" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    item1 = merchant1.items.create!(description: "sumtin", name: "a ting", unit_price: 230)
    get "/api/v1/items/#{item1.id}"

    expect(response).to be_successful
    merchant_item = JSON.parse(response.body, symbolize_names: true)

    #binding.pry
    expect(merchant_item[:data][:attributes][:merchant_id]).to eq(merchant1.id)
  end

  it "only get 1 merchants items" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    merchant2 = Merchant.create!(name: "MarksEmporium")
    item1 = merchant1.items.create!(description: "sumtin", name: "a ting", unit_price: 230)
    item2 = merchant1.items.create!(description: "atin", name: "ang", unit_price: 41)
    item3 = merchant2.items.create!(description: "mortin", name: "a ti", unit_price: 420)
    item4 = merchant2.items.create!(description: "stin", name: "ing", unit_price: 40)
    get "/api/v1/merchants/#{merchant1.id}/items"

    expect(response).to be_successful
    item_parsed = JSON.parse(response.body, symbolize_names: true)
    #binding.pry
    expect(item_parsed[:data].count).to eq(2)
    item_parsed[:data].each do |item|
      expect(item[:id]).to be_a(String)
      #binding.pry
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end
end
