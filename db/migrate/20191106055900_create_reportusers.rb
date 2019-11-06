class CreateReportusers < ActiveRecord::Migration[5.2]
  def change
    create_table :reportusers do |t|
      t.integer :from_user
      t.integer :user_id
      t.timestamps
    end
  end
end
