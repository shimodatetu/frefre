class CreateReportposts < ActiveRecord::Migration[5.2]
  def change
    create_table :reportposts do |t|
      t.integer :from_user
      t.integer :post_id
      t.timestamps
    end
  end
end
