class AddForeignKeyCraftsmanIdToNotes < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE notes
            ADD CONSTRAINT fk_notes_craftsman_id_craftsmen_employment_id
            FOREIGN KEY (craftsman_id)
            REFERENCES craftsmen(employment_id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE notes
            DROP FOREIGN KEY fk_notes_craftsman_id_craftsmen_employment_id
        SQL
      end
    end
  end
end
