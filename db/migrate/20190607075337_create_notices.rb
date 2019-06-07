class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|
      t.string :notice_from
      t.string :notice_main
      t.string :user_id
      t.string :notice_type
      t.timestamps
    end
  end
end
