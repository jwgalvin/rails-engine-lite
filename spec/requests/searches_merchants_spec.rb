require 'rails_helper'

describe 'Finds all the merchants' do
  it 'searches for and returns just 1 item' do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    merchant2 = Merchant.create!(name: "MarksEmporium")
    item1 = merchant1.items.create!(description: "sumtin", name: "a ting", unit_price: 230)
    item2 = merchant1.items.create!(description: "atin", name: "ang", unit_price: 41)
    item3 = merchant1.items.create!(description: "mortin", name: "a ti", unit_price: 420)
    item4 = merchant2.items.create!(description: "stin", name: "ing", unit_price: 40)

    get '/api/v1/items/find_all?name=ang'

    items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(items[:data].count).to eq(1)
    expect(items[:data][0][:attributes][:name]).to be_a(String)
    expect(items[:data][0][:attributes]).to have_key(:description)
    expect(items[:data][0][:attributes]).to have_key(:unit_price)
    expect(items[:data][0][:attributes]).to have_key(:merchant_id)
  end

  it 'searches for and returns just 1 item' do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    merchant2 = Merchant.create!(name: "MarksEmporium")
    item1 = merchant1.items.create!(description: "sumtin", name: "a ting", unit_price: 230)
    item2 = merchant1.items.create!(description: "atin", name: "ang", unit_price: 41)
    item3 = merchant1.items.create!(description: "mortin", name: "a ti", unit_price: 420)
    item4 = merchant2.items.create!(description: "stin", name: "ing", unit_price: 40)

    get '/api/v1/items/find_all?name=a t'

    items = JSON.parse(response.body, symbolize_names: true)
    #binding.pry
    expect(response).to be_successful
    expect(items[:data].count).to eq(2)

      items[:data].each do |item|
        #binding.pry
        expect(item[:attributes][:name]).to be_a(String)
        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes]).to have_key(:merchant_id)
      end
    end

  it 'searches for a non-existent item' do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    get '/api/v1/items/find_all?name=a'

    items = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(items[:data].count).to eq(0)
  end

  it "searches ping the merchants api and returns 1" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    merchant2 = Merchant.create!(name: "Marks Emporium")
    merchant3 = Merchant.create!(name: "Perrenial distraction Emporium")

    get '/api/v1/merchants/find?name=In'
    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    #binding.pry
    expect(merchant[:data].count).to eq(3)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
    expect(merchant[:data]).to have_key(:id)
  end

  it "searches ping the merchants api and returns 0" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    merchant2 = Merchant.create!(name: "Marks Emporium")
    merchant3 = Merchant.create!(name: "Perrenial distraction Emporium")

    get '/api/v1/merchants/find?name=park'
    merchant = JSON.parse(response.body, symbolize_names: true)
    #binding.pry
    expect(response).to_not be_successful
    expect(merchant[:data][:message]).to eq("No matching merchant")
  end

  it 'searches for and returns just 1 item' do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    item1 = merchant1.items.create!(description: "sumtin", name: "a ting", unit_price: 230)
    item2 = merchant1.items.create!(description: "atin", name: "ang", unit_price: 41)
    item3 = merchant1.items.create!(description: "mortin", name: "a ti", unit_price: 420)
    item4 = merchant1.items.create!(description: "stin", name: "ing", unit_price: 40)

    get '/api/v1/items/find_all?minimum=0'
    item_parsed = JSON.parse(response.body, symbolize_names: true)
    binding.pry
    expect(response).to_not be_successful
  end
end
