class RenameAcknowledgmentsAndAddPath < ActiveRecord::Migration[7.1]
  def change
     # Rename the table
     rename_table :acknowledgments, :pag_agreements
     add_column :pag_agreements, :path, :string
  end
end
