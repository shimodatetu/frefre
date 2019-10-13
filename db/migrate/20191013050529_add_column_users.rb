class AddColumnUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :provider, :string
    add_column :users, :oauth_token, :string
    add_column :users, :uid, :string
    add_column :users, :oauth_expires_at, :datetime
  end
end
