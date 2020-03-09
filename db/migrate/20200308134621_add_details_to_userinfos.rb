class AddDetailsToUserinfos < ActiveRecord::Migration[5.2]
  def change
    add_column :userinfos, :seen, :boolean,default:false
  end
end
