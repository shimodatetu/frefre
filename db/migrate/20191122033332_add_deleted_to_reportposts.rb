class AddDeletedToReportposts < ActiveRecord::Migration[5.2]
  def change
    add_column :reportposts, :deleted, :boolean, default: false, null: false
  end
end
