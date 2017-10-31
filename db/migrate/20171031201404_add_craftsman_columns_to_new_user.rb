class AddCraftsmanColumnsToNewUser < ActiveRecord::Migration
  def up
    add_column :new_users, :has_apprentice, :boolean
    add_column :new_users, :seeking, :boolean

    new_users = NewUser.where(user_role_id: UserRole.find_by_name('crafter').id)
    new_users.each do |user|
      execute <<-SQL
        UPDATE new_users
        SET seeking = (SELECT seeking FROM craftsmen WHERE craftsmen.email = '#{user.email}'), has_apprentice = (SELECT has_apprentice from craftsmen where craftsmen.email = '#{user.email}')
        WHERE email = '#{user.email}'
      SQL
    end
  end

  def down
    drop_column :new_users, :has_apprentice
    drop_column :new_users, :seeking
  end
end
