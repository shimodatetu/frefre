class AddDetailsToThreadtypes < ActiveRecord::Migration[5.2]
  def change
    add_column :threadtypes, :type, :string
    add_column :threadtypes, :content_en, :string
    add_column :threadtypes, :content_jp, :string
    add_column :threadtypes, :leader_id, :integer,default:0
  end
end
