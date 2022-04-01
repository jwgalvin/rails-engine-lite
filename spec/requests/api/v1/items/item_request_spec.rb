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

  it "gets 1 item" do
    create_list(:item, 10)
    get "/api/v1/items/#{Item.first.id}"
    item = Item.first
    expect(response).to be_successful
    item_parsed = JSON.parse(response.body, symbolize_names: true)
    #binding.pry

    expect(item_parsed[:data][:id]).to eq("#{item.id}")
    expect(item_parsed[:data][:type]).to eq("item")
    expect(item_parsed[:data][:attributes][:name]).to eq("#{item.name}")
    expect(item_parsed[:data][:attributes][:description]).to eq("#{item.description}")
    expect(item_parsed[:data][:attributes][:unit_price]).to eq(item.unit_price)
    expect(item_parsed[:data][:attributes][:merchant_id]).to eq(item.merchant_id)

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

  it "creates a new item" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    item_params = ({"name": "Rib stretcher Plus!", "description": "stretch their ribs without breaking!", "unit_price": 126.42, "merchant_id": merchant1.id
      })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items",headers: headers, params: JSON.generate(item: item_params)
    item_created = Item.last

    expect(response).to be_successful
    expect(item_created.name).to eq(item_params[:name])
    expect(item_created.description).to eq(item_params[:description])
    expect(item_created.unit_price).to eq(item_params[:unit_price])
    expect(item_created.merchant_id).to eq(item_params[:merchant_id])
  end

  it " can update the thing" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    item = create(:item)
    save_name = item.name
    new_name = { name: "inigo's neck stretcher"}
    #binding.pry
    header = {"CONTENT_TYPE" => "application/json"}
    patch "/api/v1/items/#{item.id}", headers: header, params:JSON.generate({item: new_name})
    item_updated = Item.find_by(id: "#{item.id}")

    expect(response).to be_successful
    expect(item_updated.name).to eq("inigo's neck stretcher")
  end

  it "will delete/destroy and item" do

    item =  create(:item)
    #binding.pry
    expect(Item.last).to eq(item)
    delete "/api/v1/items/#{item.id}"
    expect(Item.count).to eq(0)
    expect(response).to be_successful
    expect{Item.find(item.id).to raise_error(ActiveRecord::RecordNotFound)}
  end

  it 'should return the merchant' do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    item = create(:item, merchant_id: merchant1.id)
    # binding.pry
    get "/api/v1/items/#{item.id}/merchant"
    merchant = JSON.parse(response.body, symbolize_names: true)
    #binding.pry
    expect(merchant[:data].count).to eq(3)
    expect(merchant[:data][:id]).to eq("#{merchant1.id}")
    expect(merchant[:data][:attributes][:name]).to eq("#{merchant1.name}")
  end

end
