class AddUniqueConstraintToUserEmailAndLogin < ActiveRecord::Migration
  def up
    add_index :users, :email, unique: true
    add_index :users, :login, unique: true
  end

  def down
    remove_index :users, :email
    remove_index :users, :login
  end
end
