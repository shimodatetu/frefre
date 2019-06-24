class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :notice_id
      t.string :main_en
      t.string :main_jp
      t.string :image
      t.integer :user_id
      t.string :photo
      t.timestamps
    end
  end
end
