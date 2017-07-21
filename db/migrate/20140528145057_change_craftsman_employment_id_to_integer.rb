class ChangeCraftsmanEmploymentIdToInteger < ActiveRecord::Migration
  def up
    change_column :craftsmen, :employment_id, 'integer USING CAST(employment_id as integer)'
  end

  def down
    change_column :craftsmen, :employment_id, :string
  end
end
