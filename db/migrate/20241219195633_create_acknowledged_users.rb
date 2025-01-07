class CreateAcknowledgedUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :acknowledged_users do |t|
      t.string :netid, null: false

      t.timestamps
    end
    # Add a unique index to the netid column
    add_index :acknowledged_users, :netid, unique: true
  end
end
