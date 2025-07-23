class AddUserRefAndPathToPagAgreements < ActiveRecord::Migration[7.1]
  def change
    return unless table_exists?(:pag_agreements)

    add_column(:pag_agreements, :path, :string) if !column_exists?(:pag_agreements, :path)
    unless column_exists?(:pag_agreements, :user_id)
      add_reference :pag_agreements, :user, null: false, foreign_key: true
    end
  end
end
