class UpdateOriginalUserIdToEmploymentId < ActiveRecord::Migration
  def change
    if !Rails.env.test?
      crafter_role_id = execute("SELECT id from user_roles where name = 'crafter'").entries.first['id'].to_i

      craftsman_emails = NewUser.where(user_role_id: crafter_role_id).pluck(:email)

      craftsman_emails.each do |craftsman_email|
        execute("
          UPDATE new_users SET original_user_id=(SELECT employment_id from craftsmen where email='#{craftsman_email}')
          WHERE email='#{craftsman_email}'
        ")
      end
    end
  end
end
