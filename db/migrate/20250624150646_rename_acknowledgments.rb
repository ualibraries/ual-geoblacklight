class RenameAcknowledgments < ActiveRecord::Migration[7.1]
  def change
    return unless table_exists?(:acknowledgments)
    # Rename the table
    rename_table :acknowledgments, :pag_agreements
  end
end
