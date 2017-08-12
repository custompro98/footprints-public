class AddForeignKeyApplicantIdToNotes < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE notes
            ADD CONSTRAINT fk_notes_applicant_id_applicants_id
            FOREIGN KEY (applicant_id)
            REFERENCES applicants(id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE notes
            DROP FOREIGN KEY fk_notes_applicant_id_applicants_id
        SQL
      end
    end
  end
end

