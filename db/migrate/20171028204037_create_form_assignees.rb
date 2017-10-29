class CreateFormAssignees < ActiveRecord::Migration
  def up
    create_table :form_assignees do |t|
      t.integer :user_id, null: false
      t.integer :filled_form_id, null: false
      t.boolean :active, null: false, default: true
    end

    execute <<-SQL
      ALTER TABLE form_assignees
      ADD CONSTRAINT fk_form_assignees_user
      FOREIGN KEY (user_id)
      REFERENCES new_users(id)
    SQL

    execute <<-SQL
      ALTER TABLE form_assignees
      ADD CONSTRAINT fk_form_assignees_filled_form
      FOREIGN KEY (filled_form_id)
      REFERENCES filled_forms(id)
    SQL
  end

  def down
    drop_table :form_assignees
  end
end
