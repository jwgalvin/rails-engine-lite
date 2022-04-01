require 'rails_helper'

describe "Items API" do
  it "tests find_item" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    item1 = merchant1.items.create!(description: "sumtin", name: "a ting", unit_price: 230)
    item2 = merchant1.items.create!(description: "atin", name: "ang", unit_price: 41)
    item3 = merchant1.items.create!(description: "mortin", name: "a ti", unit_price: 420)
    item4 = merchant1.items.create!(description: "stin", name: "ing", unit_price: 40)

    get '/api/v1/items/find?name=ang'
    item_parsed = JSON.parse(response.body, symbolize_names: true)
    #binding.pry
    expect(item_parsed.count).to eq(1)
    expect(item_parsed[:data][:attributes][:name]).to eq("#{item2.name}")
  end

  it "Sad path: tests find_item" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    item1 = merchant1.items.create!(description: "sumtin", name: "a ting", unit_price: 230)
    item2 = merchant1.items.create!(description: "atin", name: "ang", unit_price: 41)
    item3 = merchant1.items.create!(description: "mortin", name: "a ti", unit_price: 420)
    item4 = merchant1.items.create!(description: "stin", name: "ing", unit_price: 40)

    get '/api/v1/items/find?name=sin'
    item_parsed = JSON.parse(response.body, symbolize_names: true)
    #
    expect(item_parsed[:data]).to have_key(:message)
    #expect(item_parsed[:data][:attributes][:name]).to eq("#{item2.name}")
  end

  it "tests find_max_price" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    merchant2 = Merchant.create!(name: "MarksEmporium")
    item1 = merchant1.items.create!(description: "sumtin", name: "a ting", unit_price: 230)
    item2 = merchant1.items.create!(description: "atin", name: "ang", unit_price: 41)
    item3 = merchant2.items.create!(description: "mortin", name: "a ti", unit_price: 420)
    item4 = merchant2.items.create!(description: "stin", name: "ing", unit_price: 40)
    get '/api/v1/items/find?max_price=250'
    item_parsed = JSON.parse(response.body, symbolize_names: true)
    #binding.pry
    expect(item_parsed.count).to eq(1)
    expect(item_parsed[:data]).to have_key(:attributes)
    expect(item_parsed[:data][:attributes][:name]).to eq("#{item1.name}")
  end

  it "tests find_min_price" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    merchant2 = Merchant.create!(name: "MarksEmporium")
    item1 = merchant1.items.create!(description: "sumtin", name: "a ting", unit_price: 230)
    item2 = merchant1.items.create!(description: "atin", name: "ang", unit_price: 41)
    item3 = merchant2.items.create!(description: "mortin", name: "a ti", unit_price: 420)
    item4 = merchant2.items.create!(description: "stin", name: "ing", unit_price: 40)
    get '/api/v1/items/find?min_price=250'
    item_parsed = JSON.parse(response.body, symbolize_names: true)
    #binding.pry
    expect(item_parsed.count).to eq(1)
    expect(item_parsed[:data]).to have_key(:attributes)
    expect(item_parsed[:data][:attributes][:name]).to eq("#{item3.name}")
  end
end
