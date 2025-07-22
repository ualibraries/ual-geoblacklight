class RemoveAcknowledgedUsersForeignKeyFromPagAgreements < ActiveRecord::Migration[7.1]
  def change
    return unless table_exists?(:pag_agreements)

    if foreign_key_exists?(:pag_agreements, column: :acknowledged_users_id)
      remove_foreign_key :pag_agreements, column: :acknowledged_users_id
    end

    if index_exists?(:pag_agreements, :acknowledged_users_id)
      remove_index :pag_agreements, :acknowledged_users_id
    end

    if column_exists?(:pag_agreements, :acknowledged_users_id)
      remove_column :pag_agreements, :acknowledged_users_id
    end
  end
end
