class AddDeletedToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :deleted, :boolean, default: false, null: false
  end
end
