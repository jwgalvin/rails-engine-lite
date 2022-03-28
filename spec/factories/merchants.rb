FactoryBot.define do
  factory :merchant do
    name {Faker::Name.last_name}
  end
end
