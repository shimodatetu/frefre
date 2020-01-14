class CreateThreadtypeGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :threadtype_groups do |t|
      t.integer :group_id
      t.integer :threadtype_id

      t.timestamps
    end
  end
end
