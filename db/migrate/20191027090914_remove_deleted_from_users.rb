class RemoveDeletedFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :deleted, :boolean
  end
end
