require 'rails_helper'

describe Item, type: :model do
  describe 'has relationships' do
    it { should belong_to(:items)}
    it { should have_many(:invoice_items).through(:items)}
    it { should have_many(:invoices).through(:items)}
  end
end
