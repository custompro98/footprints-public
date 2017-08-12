class AddForiegnKeyApplicantIdToAssignedCraftsman < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE assigned_craftsman_records
            ADD CONSTRAINT fk_applicant_id
            FOREIGN KEY (applicant_id)
            REFERENCES applicants(id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE assigned_craftsman_records
            DROP FOREIGN KEY fk_applicant_id
        SQL
      end
    end
  end
end
