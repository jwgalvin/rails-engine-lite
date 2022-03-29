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

end
