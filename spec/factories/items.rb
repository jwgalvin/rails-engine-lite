FactoryBot.define do
  factory :item do
    name {Faker::Appliance.equipment}
    description {Faker::Movies::StarWars.quote}
    unit_price {Faker::Number.number(digits: 4)}
    merchant
  end
end
