class AddDetailsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :threadtype_id, :integer
  end
end
