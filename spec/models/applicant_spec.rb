require 'spec_helper'

describe Applicant do
  let(:today) { Date.today }
  let(:yesterday) { Date.yesterday }
  let(:tomorrow) { Date.tomorrow }
  let(:attrs) do
    {
      :name => 'Meagan Waller',
      :email => 'meagan@test.com',
      :applied_on => yesterday,
      :discipline => 'developer',
      :skill => 'resident',
      :location => 'Chicago',
    }
  end

  let!(:craftsman) { create(:craftsman, name: 'A Craftsman') }

  it 'has available code schools' do
    Applicant.code_schools.should_not be_empty
  end

  context 'validation' do
    let(:applicant) { build(:applicant) }

    it 'requires a name, applied on date, and valid email' do
      applicant.should be_valid
    end

    it 'does not save assigned craftsman if craftsman does not exist' do
      applicant.update(:assigned_craftsman => 'Some Craftsman')
      applicant.should_not be_valid
    end

    it 'does not set hired if no decision_made_on date' do
      applicant.update(:hired => 'yes', :assigned_craftsman => 'A Craftsman')
      expect(applicant).not_to be_valid
    end

    it 'allows decision_made_on to be set with hiring decision' do
      applicant.update(:decision_made_on => DateTime.current,
                       :start_date => Date.today,
                       :end_date => Date.tomorrow,
                       :hired => 'yes',
                       :mentor => 'A Craftsman')
      expect(applicant).to be_valid
    end

    it 'does not allow hired to be set to invalid value' do
      applicant.update(:decision_made_on => DateTime.current, :hired => 'banana', :assigned_craftsman => 'A Craftsman')
      expect(applicant).not_to be_valid
    end

    it 'must have assigned craftsman with hiring decision' do
      applicant.update(:decision_made_on => DateTime.current, :hired => 'yes')
      expect(applicant).not_to be_valid
    end

    it 'must have a mentor for a hiring decision to be made' do
      applicant.update(:decision_made_on => DateTime.current, :hired => 'yes', :assigned_craftsman => 'A Craftsman')
      expect(applicant).to have(1).error_on(:mentor)
    end

    it 'does not save mentor if mentor does not exist' do
      applicant.update(:mentor => 'Unknown Craftsman')
      expect(applicant).to have(1).error_on(:mentor)
    end

    it 'requires the start date to come before the end date' do
      applicant.update(assigned_craftsman: 'A Craftsman', :decision_made_on => Date.yesterday, :hired => 'yes', :start_date => DateTime.current, :end_date => DateTime.yesterday )
      expect(applicant).not_to be_valid
    end

    it 'requires start and end date when decision is made on a applicant' do
      applicant.update(:assigned_craftsman => 'A Craftsman', :decision_made_on => Date.yesterday, :hired => 'yes')
      expect(applicant).to have(1).error_on(:start_date)
      expect(applicant).to have(1).error_on(:end_date)
    end
 end

  context 'outstanding' do
    let(:craftsman) { create(:craftsman, name: 'Tywin Lannister') }

    before do
      attrs[:applied_on] = 3.days.ago
      attrs[:assigned_craftsman] = craftsman.name
    end

    context 'there have been no replies' do
      let(:applicant) { create(:applicant, attrs) }
      let!(:assigned_craftsman_record) { create(:assigned_craftsman_record, applicant_id: applicant.id, craftsman_id: craftsman.employment_id) }

      it 'recognizes outstanding request without replies' do
        Notification.create(:applicant => applicant, :craftsman_id => craftsman.id, :created_at => 1.day.ago)
        expect(applicant.outstanding?(1)).to be_true
      end
    end

    context 'has been a reply' do
      let(:applicant) { create(:applicant, attrs.merge(has_steward: true)) }
      let!(:assigned_craftsman_record) { create(:assigned_craftsman_record, applicant_id: applicant.id, craftsman_id: craftsman.employment_id) }

      it 'request is not outstanding if there has been a reply' do
        Notification.create(:applicant => applicant, :craftsman_id => craftsman.id, :created_at => 1.day.ago)
        expect(applicant.outstanding?(1)).to be_false
      end
    end
  end

  describe 'applicant attributes' do
    let(:applicant) { build(:applicant, attrs) }

    it 'requires a valid email' do
      meagan = build(:applicant, email: 'meagan@')
      meagan.should_not be_valid
    end

    it 'does not create an applicant with an invalid code_submission' do
      applicant = Applicant.create(name: 'Foo', email: 'foo@bar.com', applied_on: Date.today, code_submission: 'bad url',
                                   :discipline => 'developer', :skill => 'resident', :location => 'Chicago')
      applicant.should_not be_valid
    end

    it 'does not create an applicant with a non-string code_submission' do
      applicant = Applicant.create(name: 'Foo', email: 'foo@bar.com', applied_on: Date.today, code_submission: '10',
                                   :discipline => 'developer', :skill => 'resident', :location => 'Chicago')
      applicant.should_not be_valid
    end

    it 'creates an applicant with a valid code_submission' do
      applicant = Applicant.create(name: 'Foo', email: 'foo@bar.com', applied_on: Date.today, code_submission: 'http://www.google.com',
                                   :discipline => 'developer', :skill => 'resident', :location => 'Chicago')
      applicant.should be_valid
    end

    it 'no dates can be future dates' do
      applicant.update(:completed_challenge_on => today + 5)
      applicant.should_not be_valid
    end

    context 'has messages' do
      let(:message) { create(:message, applicant_id: applicant.id) }

      it 'has messages' do
        applicant.messages.should == []
      end
    end

    it 'sets archived to true after decision has been made' do
      expect(applicant.archived).to be_false
      applicant.update_attribute(:decision_made_on, DateTime.current)
      expect(applicant.archived).to be_true
    end
  end
end
