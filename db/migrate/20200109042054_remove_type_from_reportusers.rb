class RemoveTypeFromReportusers < ActiveRecord::Migration[5.2]
  def change
    remove_column :reportusers, :type, :string
  end
end
