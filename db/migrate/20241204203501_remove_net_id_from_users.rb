class RemoveNetIdFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :net_id, :string
  end
end
