require 'factory_girl_rails'

module StagingSeeds
  class << self

    def run
      create_craftsmen(100)
      create_applicants(1200, 100)
      create_orphaned_users(20)
    end

    private

    def create_craftsmen(n)
      FactoryGirl.create_list(:user, n, create_craftsman: true)
    end

    def create_applicants(n, num_craftsmen)
      applicants = FactoryGirl.create_list(:applicant, n, applied_on: Faker::Date.between(12.months.ago, 8.months.ago))

      applicants.each do |applicant|
        index = Random.rand(101)
        craftsman_id = Random.rand(num_craftsmen) + 1

        applicant.initial_reply_on = Faker::Date.between(7.months.ago, 6.months.ago) if index < 90
        applicant.sent_challenge_on = Faker::Date.between(6.months.ago, 5.months.ago) if index < 60
        applicant.completed_challenge_on = Faker::Date.between(5.months.ago, 4.months.ago) if index < 30
        applicant.reviewed_on = Faker::Date.between(4.months.ago, 3.months.ago) if index < 30

        if index < 10
          applicant.decision_made_on = Faker::Date.between(2.months.ago, 1.month.ago)
          applicant.offered_on = Faker::Date.between(3.months.ago, 2.months.ago)
          applicant.start_date = applicant.offered_on + 4.months

          applicant.end_date = applicant.start_date + 365.days

          applicant.hired = 'yes'
          applicant.mentor = Craftsman.find(craftsman_id).name
          applicant.archived = true
        elsif index > 90
          applicant.hired = 'no'
          applicant.archived = true
        end

        applicant.save!


        FactoryGirl.create(:assigned_craftsman_record, applicant_id: applicant.id, craftsman_id: craftsman_id)
        FactoryGirl.create_list(:message, [2,3].sample, applicant_id: applicant.id)

        [2,3].sample.times do
          FactoryGirl.create(:note, applicant_id: applicant.id, craftsman_id: Random.rand(num_craftsmen) + 1)
          FactoryGirl.create(:notification, applicant_id: applicant.id, craftsman_id: Random.rand(num_craftsmen) + 1)
        end
      end
    end

    def create_orphaned_users(n)
      FactoryGirl.create_list(:user, n)
    end

  end
end
