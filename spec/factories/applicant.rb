FactoryGirl.define do
  factory :applicant do
    name Faker::Name.name
    applied_on Date.today
    sequence(:email) { |n| "#{n}@example.com" }
  end
end
