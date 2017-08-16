require 'spec_helper'

describe NotificationMailer do
  let(:applicant) { create(:applicant, name: "App Applicant", skill: 'skill', email: 'test@test.com', applied_on: Date.today) }
  let(:craftsman) { create(:craftsman, name: "Craft Craftsman", email: "craftsman@abcinc.com", :employment_id => "12345") }
  let!(:assigned_craftsman_record) { create(:assigned_craftsman_record, applicant_id: applicant.id, craftsman_id: craftsman.employment_id) }

  describe "#applicant_request" do
    let(:mail) { NotificationMailer.applicant_request(applicant.craftsmen, applicant) }

    it "renders the subject" do
      expect(mail.subject).to_not be_nil
    end

    it "renders the receiver" do
      expect(mail.to).to eq([craftsman.email])
    end

    it "renders the send" do
      expect(mail.from).to eq(['noreply@abcinc.com'])
    end

    it "bcc's the footprints team" do
      expect(mail.bcc).to eq([ENV["FOOTPRINTS_TEAM"]])
    end
  end
end
