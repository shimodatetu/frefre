class AddTypeToReportposts < ActiveRecord::Migration[5.2]
  def change
    add_column :reportposts, :type, :string
  end
end
