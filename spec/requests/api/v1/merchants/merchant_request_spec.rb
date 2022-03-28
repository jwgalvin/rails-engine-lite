require 'rails_helper'

describe "Merchants API" do
  before(:each) do
    create_list(:merchant, 10)
  end

  it "response grabs are the merchants" do
    get '/api/v1/merchants'

    expect(response).to be_successful
    merchant_list = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(10)
  end
end
