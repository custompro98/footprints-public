class AddCraftsmanForeignKeyToApplicants < ActiveRecord::Migration
  def up
    add_index :craftsmen, :employment_id, unique: true

    execute <<-SQL
      ALTER TABLE applicants
      ADD CONSTRAINT fk_applicants_craftsman
      FOREIGN KEY (craftsman_id)
      REFERENCES craftsmen(employment_id)
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE applicants
      DROP CONSTRAINT fk_applicants_craftsman
    SQL

    remove_index :craftsmen, :employment_id
  end
end
