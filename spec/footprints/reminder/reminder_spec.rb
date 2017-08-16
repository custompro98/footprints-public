require './lib/reminder/reminder.rb'
require 'spec_helper'
require 'spec_helpers/applicant_factory'
require 'spec_helpers/craftsman_factory'

describe Footprints::Reminder do
  let(:applicant_factory) { SpecHelpers::ApplicantFactory.new }
  let(:craftsman_factory) { SpecHelpers::CraftsmanFactory.new }
  let!(:steward) { create(:craftsman, email: ENV['STEWARD']) }
  let(:craftsman) { create(:craftsman, name: 'A. Craftsman', email: 'craftsman@example.com') }
  let(:applicant) { create(:applicant, applied_on: applied_on, created_at: created_at, assigned_craftsman: craftsman.name) }
  let!(:assigned_craftsman_record) { create(:assigned_craftsman_record, craftsman_id: craftsman.employment_id, applicant_id: applicant.id) }

  before :each do
    ActionMailer::Base.deliveries = []
  end

  context 'outstanding 1 day' do
    let(:applied_on) { 1.day.ago }
    let(:created_at) { 1.day.ago }

    it "reminds craftsman when the applicant is outstanding 1 day" do
      notifications = Notification.where(:applicant => applicant, :craftsman => applicant.craftsmen.first)
      expect(notifications.count).to eq(0)
      described_class.notify_craftsman_of_outstanding_requests
      expect(notifications.reload.count).to eq(1)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  context 'not outstanding' do
    let(:created_at) { Date.today }

    context 'as a craftsman' do
      let(:applied_on) { Date.today }

      it "doesn't remind craftsman if applicant is not outstanding" do
        notifications = Notification.where(:applicant => applicant, :craftsman => applicant.craftsmen.first)
        expect(notifications.count).to eq(0)
        described_class.notify_craftsman_of_outstanding_requests
        expect(notifications.reload.count).to eq(0)
      end
    end

    context 'as a steward' do
      let(:applied_on) { 7.days.ago }
      it "doesn't remind steward if applicant is not outstanding" do
        described_class.notify_craftsman_of_outstanding_requests
        notifications = Notification.where(:applicant => applicant, :craftsman => steward)
        expect(notifications.count).to eq(0)
      end
    end
  end

  context 'outstanding 3 days' do
    let(:applied_on) { 3.days.ago }

    context 'created at today' do
      let(:created_at) { Date.today }

      it "reminds steward when the applicant is outstanding 3 days" do
        notifications = Notification.where(:applicant => applicant, :craftsman => steward)
        expect(notifications.count).to eq(0)
        Notification.create(:applicant => applicant, :craftsman => applicant.craftsmen.first,
                            :created_at => 2.days.ago)
        described_class.notify_craftsman_of_outstanding_requests
        expect(notifications.reload.count).to eq(1)
      end
    end

    context 'created 3 days ago' do
      let(:created_at) { 3.days.ago }

      it "only reminds steward once" do
        notification = Notification.create(:applicant => applicant, :craftsman => steward)
        expect(steward.notifications.count).to eq(1)
        described_class.notify_craftsman_of_outstanding_requests
        expect(steward.notifications.count).to eq(1)
      end
    end
  end

end
