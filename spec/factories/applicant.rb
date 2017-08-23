FactoryGirl.define do
  factory :applicant do
    name { Faker::Name.name }
    applied_on Date.today
    sequence(:email) { |n| "applicant_#{n}@example.com" }

    skill { ['craftsman', 'student', 'resident'].sample }
    discipline { ['developer', 'designer'].sample }
    location { ['Chicago', 'London', 'Los Angeles'].sample }
    about { Faker::Company.catch_phrase }
    software_interest { Faker::Hacker.say_something_smart }
    reason { Faker::Superhero.name }
  end
end
