class AddNotNullConstraintsToApplicant < ActiveRecord::Migration
  def up
    change_column_null :applicants, :name, false
    change_column_null :applicants, :applied_on, false
  end

  def down
    change_column_null :applicants, :name, true
    change_column_null :applicants, :applied_on, true
  end
end
