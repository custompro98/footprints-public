class CreateAnswers < ActiveRecord::Migration
  def up
    create_table :answers do |t|
      t.integer :user_id, null: false
      t.integer :field_id, null: false
      t.integer :filled_form_id, null: false
      t.integer :field_choice_id
      t.string :answer_text
    end

    execute <<-SQL
      ALTER TABLE answers
      ADD CONSTRAINT fk_answers_user
      FOREIGN KEY (user_id)
      REFERENCES new_users(id)
    SQL

    execute <<-SQL
      ALTER TABLE answers
      ADD CONSTRAINT fk_answers_field
      FOREIGN KEY (field_id)
      REFERENCES fields(id)
      ON DELETE CASCADE
    SQL

    execute <<-SQL
      ALTER TABLE answers
      ADD CONSTRAINT fk_answers_filled_form
      FOREIGN KEY (filled_form_id)
      REFERENCES filled_forms(id)
    SQL

    execute <<-SQL
      ALTER TABLE answers
      ADD CONSTRAINT fk_answers_field_choice
      FOREIGN KEY (field_choice_id)
      REFERENCES field_choices(id)
      ON DELETE CASCADE
    SQL
  end

  def down
    drop_table :answers
  end
end
