class RenameNetIdToNetidInAcknowledgedUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :acknowledged_users, :net_id, :netid
  end
end
