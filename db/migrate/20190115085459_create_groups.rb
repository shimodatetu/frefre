class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      #t.string :lang
      t.string :title_en
      t.string :title_jp
      t.integer :user_id
      #t.integer :smallcategory_id
      #t.integer :bigcategory_id
      t.integer :threadtype_id
      t.integer :seen_num, default: 0
      t.timestamps
    end
  end
end
