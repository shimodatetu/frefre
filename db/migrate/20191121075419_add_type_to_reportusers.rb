class AddTypeToReportusers < ActiveRecord::Migration[5.2]
  def change
    add_column :reportusers, :type, :string
  end
end
