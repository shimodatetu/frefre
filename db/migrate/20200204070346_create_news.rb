class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.string :title_en
      t.string :title_jp
      t.string :content_en
      t.string :content_jp
      t.integer :user_id

      t.timestamps
    end
  end
end
