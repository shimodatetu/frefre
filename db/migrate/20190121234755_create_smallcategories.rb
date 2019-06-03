class CreateSmallcategories < ActiveRecord::Migration[5.2]
  def change
    create_table :smallcategories do |t|
      t.string :name_en
      t.string :name_jp
      #t.integer :bigcategory_id
      t.timestamps
    end
  end
end
