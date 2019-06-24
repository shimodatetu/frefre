class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|
      t.integer :notice_from
      t.string :title_en
      t.string :title_jp
      t.string :user_id
      t.timestamps
    end
  end
end
