class CreateReportthreadtypes < ActiveRecord::Migration[5.2]
  def change
    create_table :reportthreadtypes do |t|
      t.integer :threadtype_id
      t.integer :user_id
      t.string :reporttype
      t.string :content
      t.boolean :deleted
      t.timestamps
    end
  end
end
