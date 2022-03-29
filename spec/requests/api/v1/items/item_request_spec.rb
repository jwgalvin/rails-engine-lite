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

  xit "Verifies that all merchants have all the attributes" do
    create_list(:item, 10)
    get '/api/v1/items'

    expect(response).to be_successful
    item_list = JSON.parse(response.body, symbolize_names: true)
    item_list[:data].each do |item|
      binding.pry
      expect(item[:id]).to be_a(String)
      expect(item[:type]).to eq("item")
      expect(item[:attributes][:name]).to be_a(String)

    end
  end
  xit "only get 1 merchant" do
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

end
