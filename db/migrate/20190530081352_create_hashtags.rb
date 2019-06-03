class CreateHashtags < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtags do |t|
      t.string :hash_en
      t.string :hash_jp
      t.string :group_id
      t.timestamps
    end
  end
end
