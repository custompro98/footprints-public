FactoryGirl.define do
  factory :message do

    before(:create) do |message|
      message.applicant_id ||= create(:applicant).id
    end
  end
end
