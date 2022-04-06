class ItemsSoldSerializer
  include JSONAPI::Serializer

  attributes :name

  attribute :count do |object|
    object.quantity_sold
  end
end
