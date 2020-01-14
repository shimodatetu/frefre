class AddReporttypeToReportposts < ActiveRecord::Migration[5.2]
  def change
    add_column :reportposts, :reporttype, :string
  end
end
