require './lib/applicants/applicant_presenter'

class NotificationMailer < ActionMailer::Base
  default :from => "noreply@abcinc.com"

  def applicant_request(craftsman, applicant)
    @craftsman = craftsman
    @applicant = applicant

    mail :to => Rails.env.staging? ? ENV["TEST_EMAIL"] : craftsman.email,
      :bcc => ENV["FOOTPRINTS_TEAM"], :subject => "[Footprints] You're the steward for #{@applicant.name}"
  end

  def craftsman_reminder(applicant)
    @craftsmen = applicant.craftsmen
    @applicant = applicant

    mail to: Rails.env.staging? ? ENV["TEST_EMAIL"] : @craftsmen.map(&:email).join(','),
         subject: "[Footprints] REMINDER: You're the steward for #{@applicant.name}"
  end

  def steward_reminder(applicant)
    @applicant = applicant
    @craftsmen = applicant.craftsmen

    mail to: ENV["FOOTPRINTS_TEAM"],
         subject: "[Footprints] REMINDER: #{@craftsmen.map(&:name).join(',')} has not responded regarding #{@applicant.name}"
  end

  def new_craftsman_transfer(prev_craftsmen, new_craftsman, applicant)
    @applicant = applicant
    @new_craftsman = new_craftsman
    @prev_craftsmen = prev_craftsmen

    mail to: Rails.env.staging? ? ENV["TEST_EMAIL"] : new_craftsman.email,
         subject: "[Footprints] You are now the steward for #{applicant.name}"
  end

  def prev_craftsman_transfer(prev_craftsmen, new_craftsman, applicant)
    @prev_craftsmen = prev_craftsmen
    @new_craftsman = new_craftsman
    @applicant = applicant

    prev_craftsman_emails = Array.wrap(prev_craftsmen).map(&:email).join(',')

    mail to: Rails.env.staging? ? ENV["TEST_EMAIL"] : prev_craftsman_emails,
         subject: "[Footprints] #{new_craftsman.name} is now the steward for #{applicant.name}"
  end

  def offer_letter_generated(applicant)
    @applicant = applicant

    mail :to => [ENV["ADMIN_EMAIL"], ENV["CFO_EMAIL"]], :subject => "[Footprints] An offer letter has been generated for #{applicant.name}"
  end

  def applicant_hired(applicant)
    @applicant = applicant
    craftsman = Craftsman.find_by_name(applicant.assigned_craftsman)

    mail :to => [Rails.env.staging? ? ENV["TEST_EMAIL"] : craftsman.email, ENV["ADMIN_EMAIL"], ENV["CFO_EMAIL"]], :subject => "[Footprints] A decision has been made on applicant #{applicant.name}"
  end

  def dispatcher_failed_to_assign_applicant(applicant, error)
    @applicant = applicant
    @error = error
    mail :to => ENV["FOOTPRINTS_TEAM"], :subject => "[Footprints] Dispatcher failed to assign applicant #{applicant.name}"
  end
end
