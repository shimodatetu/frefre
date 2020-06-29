class AddUserSearchIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_search_id, :string
  end
end
