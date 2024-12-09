class CreateAcknowledgedUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :acknowledged_users do |t|
      t.string :netid

      t.timestamps
    end
  end
end
