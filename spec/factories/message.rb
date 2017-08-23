FactoryGirl.define do
  factory :message do
    title { Faker::Hipster.sentence(4) }
    body { Faker::Hipster.sentence(8) }

    before(:create) do |message|
      message.applicant_id ||= create(:applicant).id
    end
  end
end
