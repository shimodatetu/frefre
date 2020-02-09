class AddDetailsToChat < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :subtitle_en, :string
    add_column :chats, :subtitle_jp, :string
  end
end
