FactoryGirl.define do
  factory :note do
    body { Faker::Hipster.sentence(8) }

    before(:create) do |note|
      note.applicant_id ||= create(:applicant).id
      note.craftsman_id ||= create(:craftsman).id
    end
  end
end
