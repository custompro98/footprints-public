class CreateNewUsers < ActiveRecord::Migration
  def up
    create_table :new_users do |t|
      t.string :email, null: false, unique: true
      t.string :name, null: false
      t.string :location, null: false
      t.integer :user_role_id, null: false
      t.boolean :archived, null: false, default: false
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE new_users
      ADD CONSTRAINT fk_users_user_roles
      FOREIGN KEY (user_role_id)
      REFERENCES user_roles(id)
    SQL
  end

  def down
    drop_table :new_users
  end
end
