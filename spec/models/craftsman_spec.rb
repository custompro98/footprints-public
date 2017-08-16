require 'spec_helper'

describe Craftsman do
  let(:attrs) {{
    name: "Bob",
    status: "Seeking apprentice",
    employment_id: "employment_id",
    skill: '1'
  }}

  let(:craftsman) { create(:craftsman, attrs) }
  let(:applicant) { create(:applicant) }
  let(:archived_applicant) { create(:applicant, archived: true) }

  let!(:record) { create(:assigned_craftsman_record, craftsman_id: craftsman.id, applicant_id: applicant.id) }
  let!(:archived_record) { create(:assigned_craftsman_record, craftsman_id: craftsman.id, applicant_id: archived_applicant.id) }

  it "associates applicant(s) with craftsman" do
    craftsman.applicants.first.should == applicant
  end

  it "returns not_archived applicants by default" do
    craftsman.applicants.should_not include(archived_applicant)
  end

  it "can set craftsman to archived" do
    craftsman.archived.should == false
    craftsman.flag_archived!
    craftsman.reload.archived.should == true
  end

  it "creates footprints steward on staging even when default employment_id is taken" do
    create(:craftsman, employment_id: 999)

    Craftsman.create_footprints_steward(999)
    steward = Craftsman.find_by_email(ENV["STEWARD"])
    expect(steward.employment_id).to eq(1000)
  end

  describe '#is_seeking_for?' do
    let(:craftsman) { create(:craftsman, attrs.merge(skill: 3)) }
    context 'skills by key' do
      it 'matches skills by id' do
        expect(craftsman.is_seeking_for? 3).to eq(true)
      end

      it 'only matches available skills' do
        expect(craftsman.is_seeking_for? 2).to eq(false)
      end
    end
  end
end
