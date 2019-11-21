class AddContentToReportusers < ActiveRecord::Migration[5.2]
  def change
    add_column :reportusers, :content, :string
  end
end
