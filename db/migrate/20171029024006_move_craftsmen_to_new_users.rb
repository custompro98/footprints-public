class MoveCraftsmenToNewUsers < ActiveRecord::Migration
  def up
    crafter_role = ::UserRole.create(name: 'crafter')

    execute <<-SQL
      INSERT INTO new_users(email, name, location, user_role_id, archived, created_at, updated_at)
      SELECT coalesce(email, 'test@example.com'), name, location, #{crafter_role.id}, archived, now(), now()
      FROM craftsmen
    SQL
  end

  def down
  end
end
