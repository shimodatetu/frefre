class AddThreadtypeIdToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :threadtype_id, :integer
  end
end
