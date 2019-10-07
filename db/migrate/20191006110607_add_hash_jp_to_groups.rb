class AddHashJpToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :hash_jp, :string
  end
end
