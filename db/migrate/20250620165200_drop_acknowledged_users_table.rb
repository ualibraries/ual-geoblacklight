class DropAcknowledgedUsersTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :acknowledged_users, if_exists: true
  end
end
