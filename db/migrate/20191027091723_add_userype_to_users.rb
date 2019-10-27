class AddUserypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :usertype, :string,default:"normal"
  end
end
