FactoryBot.define do
  factory :item do
    name {Faker::Appliance.equipment}
    description {Faker::Movies::Starwars.quote}
    unit_price {Faker::Number(digits: 4)}
    merchant
  end
end
