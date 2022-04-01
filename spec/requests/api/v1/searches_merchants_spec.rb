require 'rails_helper'

describe 'Finds the merchants:::' do
  it 'searches for and returns all with search merchant' do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    merchant2 = Merchant.create!(name: "MarksEmporium")
    merchant3 = Merchant.create!(name: "Perrenial distraction Emporium")
    merchant4 = Merchant.create!(name: "Marta Emporium")
    

    get '/api/v1/merchants/find_all?name=emp'

    merchants = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    #binding.pry
    expect(merchants[:data].count).to eq(4)
    merchants[:data].each do |merchant|
      expect(merchant[:attributes][:name]).to be_a(String)
      expect(merchant[:attributes]).to have_key(:name)
    end
  end

  it 'sad path for a non-existent merchant' do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    merchant2 = Merchant.create!(name: "Marks Emporium")
    merchant3 = Merchant.create!(name: "Perrenial distraction Emporium")
    merchant4 = Merchant.create!(name: "Notta Emporium")
    get '/api/v1/merchants/find_all?name='
    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to_not be_successful
    #expect(merchant[:data].count).to eq(0)
  end

  it "searches ping the merchants api and returns 1" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    merchant2 = Merchant.create!(name: "Marks Emporium")
    merchant3 = Merchant.create!(name: "Perrenial distraction Emporium")

    get '/api/v1/merchants/find?name=In'
    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful

    expect(merchant[:data].count).to eq(3) #ID, attributes, type
    expect(merchant[:data][:attributes][:name]).to be_a(String)
    expect(merchant[:data]).to have_key(:id)
  end

  it "sad path: look for merchants that doesn't exist, returns 0" do
    merchant1 = Merchant.create!(name: "Inigo's Revenge Emporium")
    merchant2 = Merchant.create!(name: "Marks Emporium")
    merchant3 = Merchant.create!(name: "Perrenial distraction Emporium")

    get '/api/v1/merchants/find?name=park'
    merchant = JSON.parse(response.body, symbolize_names: true)
    #binding.pry
    expect(response).to_not be_successful
    expect(merchant[:data][:message]).to eq("No matching merchant")
  end


end
