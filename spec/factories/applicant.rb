FactoryGirl.define do
  factory :applicant do
    name Faker::Name.name
    applied_on Date.today
  end
end
