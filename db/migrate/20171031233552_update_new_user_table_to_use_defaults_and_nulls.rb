class UpdateNewUserTableToUseDefaultsAndNulls < ActiveRecord::Migration
  def change
    change_column :new_users, :email, :string, null: true
    change_column :new_users, :location, :string, default: 'Chicago'
  end
end
