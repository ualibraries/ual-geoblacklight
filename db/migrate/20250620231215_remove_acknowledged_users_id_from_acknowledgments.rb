class RemoveAcknowledgedUsersIdFromAcknowledgments < ActiveRecord::Migration[7.1]
  def change
    return unless table_exists?(:acknowledgments)
     # Safely remove the foreign key if it exists
    if foreign_key_exists?(:acknowledgments, column: :acknowledged_users_id)
      remove_foreign_key :acknowledgments, column: :acknowledged_users_id
    end

    # Safely remove the index if it exists
    if index_exists?(:acknowledgments, :acknowledged_users_id)
      remove_index :acknowledgments, :acknowledged_users_id
    end

    # Safely remove the column if it exists
    if column_exists?(:acknowledgments, :acknowledged_users_id)
      remove_column :acknowledgments, :acknowledged_users_id
    end
  end
end
