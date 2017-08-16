class AddNotNullConstraintToCraftsman < ActiveRecord::Migration
  def up
    change_column_null :craftsmen, :employment_id, false
  end

  def down
    change_column_null :craftsmen, :employment_id, true
  end
end
