class AddForeignKeyApplicantIdToNotifications < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE notifications
            ADD CONSTRAINT fk_applicant_id
            FOREIGN KEY (applicant_id)
            REFERENCES applicants(id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE notifications
            DROP FOREIGN KEY fk_applicant_id
        SQL
      end
    end
  end
end
