class AddUniqueEmailConstraintToApplicants < ActiveRecord::Migration
  def up
    add_index :applicants, :email, unique: true
    add_index :applicants, :code_submission, unique: true
  end

  def down
    remove_index :applicants, :email
    remove_index :applicants, :code_submission
  end
end
