class CreateFields < ActiveRecord::Migration
  def up
    create_table :fields do |t|
      t.string :name, null: false
      t.string :form_type, null: false
      t.boolean :has_choices, null: false
    end
  end

  def down
    drop_table :fields
  end
end
