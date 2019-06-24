class CreateNoticesUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :notices_users do |t|
      t.references :notice, index: true, null: false
      t.references :user, index: true, null: false
    end
  end
end
