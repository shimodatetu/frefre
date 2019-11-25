class RemoveDeleteFromReportpost < ActiveRecord::Migration[5.2]
  def change
    remove_column :reportposts, :delete, :boolean
  end
end
