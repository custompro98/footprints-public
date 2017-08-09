class RemoveCraftsmanIdFromApplicants < ActiveRecord::Migration
  def up
    remove_column :applicants, :craftsman_id
  end

  def down
    add_column :applicants, :craftsman_id, :integer
  end
end
