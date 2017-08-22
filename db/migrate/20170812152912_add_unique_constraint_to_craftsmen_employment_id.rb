class AddUniqueConstraintToCraftsmenEmploymentId < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE craftsmen
            ADD CONSTRAINT unique_employment_id UNIQUE (employment_id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE craftsmen
            DROP CONSTRAINT unique_employment_id
        SQL
      end
    end
  end
end
