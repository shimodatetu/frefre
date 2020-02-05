class AddDetailsToNews < ActiveRecord::Migration[5.2]
  def change

    add_column :news, :subtitle_en, :string
    add_column :news, :subtitle_jp, :string
  end
end
