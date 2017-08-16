FactoryGirl.define do
  factory :assigned_craftsman_record do
    before(:create) do |record|
      record.applicant_id ||= create(:applicant).id
      record.craftsman_id ||= create(:craftsman).employment_id
    end
  end
end
