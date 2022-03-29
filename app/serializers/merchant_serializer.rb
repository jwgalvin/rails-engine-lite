class MerchantSerializer
  include JSONAPI::Serializer

  set_type :merchant
  set_id :id
  attributes :name

  has_many :items
end
