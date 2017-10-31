class CreateFilledForms < ActiveRecord::Migration
  def up
    create_table :filled_forms do |t|
      t.integer :applicant_id, null: false
      t.integer :filler_id, null: false
      t.string :form_type, null: false
      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE filled_forms
      ADD CONSTRAINT fk_filled_forms_applicant
      FOREIGN KEY (applicant_id)
      REFERENCES new_users(id)
    SQL

    execute <<-SQL
      ALTER TABLE filled_forms
      ADD CONSTRAINT fk_filled_forms_filler
      FOREIGN KEY (filler_id)
      REFERENCES new_users(id)
    SQL
  end

  def down
    drop_table :filled_forms
  end
end
