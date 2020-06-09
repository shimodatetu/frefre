class AddCategoryIdToThreadtypes < ActiveRecord::Migration[5.2]
  def change
    add_column :threadtypes, :categry_id, :integer
  end
end
