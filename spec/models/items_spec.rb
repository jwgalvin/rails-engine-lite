require 'rails_helper'

describe Item, type: :model do
  describe 'has relationships' do
    it { should belong_to(:merchant)}
    it { should have_many(:invoice_items)}
  end
end
