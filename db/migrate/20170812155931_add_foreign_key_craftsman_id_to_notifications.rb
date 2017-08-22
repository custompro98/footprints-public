class AddForeignKeyCraftsmanIdToNotifications < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE notifications
            ADD CONSTRAINT fk_notifications_craftsman_id_craftsmen_employment_id
            FOREIGN KEY (craftsman_id)
            REFERENCES craftsmen(employment_id)
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE notifications
            DROP FOREIGN KEY fk_notifications_craftsman_id_craftsmen_employment_id
        SQL
      end
    end
  end
end
