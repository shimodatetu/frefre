class AddDeletedToReportusers < ActiveRecord::Migration[5.2]
  def change
    add_column :reportusers, :deleted, :boolean, default: false, null: false
  end
end
