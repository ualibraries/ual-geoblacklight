class RemovePathFromPagAgreement < ActiveRecord::Migration[7.1]
  def change
     if column_exists?(:pag_agreements, :path)
      remove_column :pag_agreements, :path, :string
    end
  end
end
