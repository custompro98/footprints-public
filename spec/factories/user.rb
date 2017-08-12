FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "#{n}@example.com" }

    transient do
      create_craftsman false
    end

    before(:create) do |user, evaluator|
      create(:craftsman, email: user.email) if evaluator.create_craftsman
    end
  end
end
