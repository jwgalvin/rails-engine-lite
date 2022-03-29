require 'rails_helper'

describe Merchant, type: :model do
  describe 'has relationships' do
    
    it { should have_many(:invoice_items)}
    it { should have_many(:invoices).through(:invoice_items)}
  end
end
