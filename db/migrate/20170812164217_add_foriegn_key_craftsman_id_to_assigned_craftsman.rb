class AddForiegnKeyCraftsmanIdToAssignedCraftsman < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE assigned_craftsman_records
            ADD CONSTRAINT fk_craftsmen_employment_id_assigned_craftsman_records_craftsman_id
            FOREIGN KEY (craftsman_id)
            REFERENCES craftsmen(employment_id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE fk_craftsmen_employment_id_assigned_craftsman_records_craftsman_id
            DROP FOREIGN KEY fk_craftsman_id
        SQL
      end
    end
  end
end
