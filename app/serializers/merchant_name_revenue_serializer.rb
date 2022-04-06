class MerchantNameRevenueSerializer

  include JSONAPI::Serializer
  attributes :name
  attribute :revenue do |merch|
    merch.total_revenue
  end
end
