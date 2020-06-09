class CreateUserThreadtypes < ActiveRecord::Migration[5.2]
  def change
    create_table :user_threadtypes do |t|

      t.timestamps
    end
  end
  def change
    create_table :user_threadtypes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :threadtype, index: true, foreign_key: true
      t.timestamps
    end
  end
end
