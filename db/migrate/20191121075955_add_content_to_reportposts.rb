class AddContentToReportposts < ActiveRecord::Migration[5.2]
  def change
    add_column :reportposts, :content, :string
  end
end
