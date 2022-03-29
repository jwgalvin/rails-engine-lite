require 'rails_helper'

describe Merchant, type: :model do
  describe 'has relationships' do
    # it { should have_many()}
    it { should have_many(:items)}
    it { should have_many(:invoice_items).through(:items)}
  end
end
