class CreateFieldChoices < ActiveRecord::Migration
  def up
    create_table :field_choices do |t|
      t.string :name, null: false
      t.integer :field_id, null: false
    end

    execute <<-SQL
      ALTER TABLE field_choices
      ADD CONSTRAINT fk_field_choices_field
      FOREIGN KEY (field_id)
      REFERENCES fields(id)
      ON DELETE CASCADE
    SQL
  end

  def down
    drop_table :field_choices
  end
end
