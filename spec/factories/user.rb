FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "#{n}@example.com" }

    transient do
      create_craftsman false
    end

    before(:create) do |user, evaluator|
      craftsman = create(:craftsman, email: user.email) if evaluator.create_craftsman
      user.craftsman_id = craftsman.id if evaluator.create_craftsman
    end
  end
end
