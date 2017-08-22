FactoryGirl.define do
  factory :craftsman do
    sequence :employment_id

    name { Faker::Name.name }
    location { Faker::Address.city }
    sequence(:email) { |n| "craftsman_#{n}@example.com" }
    seeking true
    has_apprentice { [true, false].sample }
    skill { [1,2].sample }
  end
end

