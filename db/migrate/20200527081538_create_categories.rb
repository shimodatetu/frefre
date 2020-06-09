class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :type_en
      t.string :type_jp
      t.integer :threadtype_id
      t.timestamps
    end
  end
end
