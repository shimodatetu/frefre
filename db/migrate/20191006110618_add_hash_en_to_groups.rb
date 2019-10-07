class AddHashEnToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :hash_en, :string
  end
end
