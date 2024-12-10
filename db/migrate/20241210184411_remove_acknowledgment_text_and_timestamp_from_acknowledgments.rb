class RemoveAcknowledgmentTextAndTimestampFromAcknowledgments < ActiveRecord::Migration[7.1]
  def change
    remove_column :acknowledgments, :acknowledgment_text, :string
    remove_column :acknowledgments, :timestamp, :datetime
  end
end
