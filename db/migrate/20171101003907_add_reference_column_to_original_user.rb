class AddReferenceColumnToOriginalUser < ActiveRecord::Migration
  def change
    add_column :new_users, :original_user_id, :integer

    if !Rails.env.test?
      applicant_role_id = execute("SELECT id from user_roles where name = 'applicant'").entries.first['id'].to_i
      crafter_role_id = execute("SELECT id from user_roles where name = 'crafter'").entries.first['id'].to_i

      applicant_emails = NewUser.where(user_role_id: applicant_role_id).pluck(:email)
      craftsman_emails = NewUser.where(user_role_id: crafter_role_id).pluck(:email)

      applicant_emails.each do |applicant_email|
        execute("
          UPDATE new_users SET original_user_id=(SELECT id from applicants where email='#{applicant_email}')
          WHERE email='#{applicant_email}'
        ")
      end

      craftsman_emails.each do |craftsman_email|
        execute("
          UPDATE new_users SET original_user_id=(SELECT employment_id from craftsmen where email='#{craftsman_email}')
          WHERE email='#{craftsman_email}'
        ")
      end
    end

    change_column :new_users, :original_user_id, :integer, null: false
  end
end
