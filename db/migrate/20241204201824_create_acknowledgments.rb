class CreateAcknowledgments < ActiveRecord::Migration[7.1]
  def change
    create_table :acknowledgments do |t|
      t.references :acknowledged_user, null: false, foreign_key: true
      t.string :acknowledgment_text
      t.datetime :timestamp

      t.timestamps
    end
  end
end
