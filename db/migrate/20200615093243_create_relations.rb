class CreateRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :relations do |t|
      t.integer :joiner_id
      t.integer :joining_id

      t.timestamps null: false
    end

    add_index :relations, :joiner_id
    add_index :relations, :joining_id
    add_index :relations, [:joiner_id, :joining_id], unique: true
  end
end