class AddDetailsToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :subtitle_en, :string, default: "", null: ""
    add_column :posts, :subtitle_jp, :string, default: "", null: ""
  end
end
