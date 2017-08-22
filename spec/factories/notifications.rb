FactoryGirl.define do
  factory :notification do

    before(:create) do |notification|
      notification.applicant_id ||= create(:applicant).id
      notification.craftsman_id ||= create(:craftsman).id
    end
  end
end
