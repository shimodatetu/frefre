class AddDetailsToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :first_content_en, :string
    add_column :groups, :first_content_jp, :string
  end
end
