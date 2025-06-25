class RemoveAcknowledgedUsersIdFromAcknowledgments < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :acknowledgments, column: :acknowledged_users_id rescue nil
    remove_index :acknowledgments, :acknowledged_users_id
    remove_column :acknowledgments, :acknowledged_users_id
  end
end
