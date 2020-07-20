class CreateReportgroups < ActiveRecord::Migration[5.2]
  def change
    create_table :reportgroups do |t|
      t.integer :user_id
      t.integer :group_id
      t.string :reporttype
      t.string :content
      t.boolean :deleted
      t.timestamps
    end
  end
end

