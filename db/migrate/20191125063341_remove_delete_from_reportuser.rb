class RemoveDeleteFromReportuser < ActiveRecord::Migration[5.2]
  def change
    remove_column :reportusers, :delete, :boolean
  end
end
