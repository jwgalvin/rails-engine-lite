require 'rails_helper'

describe "Items API" do
  it "sad paths a blank parse" do
    get '/api/v1/items'

    expect(response).to be_successful
    item_list = JSON.parse(response.body, symbolize_names: true)

    expect(item_list[:data].count).to eq(0)
  end

  it "response grabs all the items" do
    create_list(:item, 10)
    get '/api/v1/items'

    expect(response).to be_successful
    item_list = JSON.parse(response.body, symbolize_names: true)

    expect(item_list[:data].count).to eq(10)
  end

  it "Verifies that all items have all the attributes" do
    create_list(:item, 10)
    get '/api/v1/items'

    expect(response).to be_successful
    item_list = JSON.parse(response.body, symbolize_names: true)
    item_list[:data].each do |item|
      #binding.pry
      expect(item[:id]).to be_a(String)
      expect(item[:type]).to eq("item")
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
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
    item_parsed[:data].each do |item|
      expect(item[:id]).to be_a(String)
      #binding.pry
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it "only get 1 item" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    item1 = merchant1.items.create!(description: "sumtin", name: "a ting", unit_price: 4000)
    get "/api/v1/merchants/#{merchant1.id}/items/#{item1.id}"

    expect(response).to be_successful
    item_parsed = JSON.parse(response.body, symbolize_names: true)
    #binding.pry
    expect(item_parsed[:data][:id]).to be_a(String)
    expect(item_parsed[:data][:attributes][:merchant_id]).to eq(merchant1.id)
    expect(item_parsed[:data][:attributes][:name]).to be_a(String)
    expect(item_parsed[:data][:attributes][:name]).to eq(item1.name)
    expect(item_parsed[:data][:attributes][:description]).to eq(item1.description)
    expect(item_parsed[:data][:attributes][:unit_price]).to eq(item1.unit_price)

  end

end
