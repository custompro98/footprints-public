class AddForeignKeyCraftsmanIdToApplicant < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE applicants
            ADD CONSTRAINT fk_craftsman_id
            FOREIGN KEY (craftsman_id)
            REFERENCES craftsmen(employment_id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE applicants
            DROP FOREIGN KEY fk_craftsman_id
        SQL
      end
    end
  end
end
