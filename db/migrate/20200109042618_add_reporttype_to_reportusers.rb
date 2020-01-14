class AddReporttypeToReportusers < ActiveRecord::Migration[5.2]
  def change
    add_column :reportusers, :reporttype, :string
  end
end
