class CreateUserinfos < ActiveRecord::Migration[5.2]
  def change
    create_table :userinfos do |t|

      t.timestamps
      t.integer :user_id
      t.integer :type
      t.string :title_en
      t.string :title_jp
      t.string :message_en
      t.string :message_jp
    end
  end
end
