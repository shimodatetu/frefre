class CreateUserNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :user_notices do |t|
      t.integer :notice_id
      t.integer :user_id

      t.timestamps
    end
  end
end
