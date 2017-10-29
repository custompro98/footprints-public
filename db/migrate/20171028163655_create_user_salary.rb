class CreateUserSalary < ActiveRecord::Migration
  def up
    create_table :user_salaries do |t|
      t.integer :user_id, null: false
      t.integer :amount, null: false
      t.boolean :monthly, null: false
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE user_salaries
      ADD CONSTRAINT fk_users_user_salaries
      FOREIGN KEY (user_id)
      REFERENCES new_users(id)
    SQL
  end

  def down
    drop_table :user_salaries
  end
end
