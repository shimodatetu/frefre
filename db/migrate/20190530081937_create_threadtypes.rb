class CreateThreadtypes < ActiveRecord::Migration[5.2]
  def change
    create_table :threadtypes do |t|
      t.string :type_en
      t.string :type_jp
      t.timestamps
    end
  end
end
