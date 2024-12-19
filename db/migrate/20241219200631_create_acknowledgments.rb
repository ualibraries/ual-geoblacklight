class CreateAcknowledgments < ActiveRecord::Migration[7.1]
  def change
    create_table :acknowledgments do |t|
      t.references :acknowledged_users, null: false, foreign_key: true

      t.timestamps
    end
  end
end
