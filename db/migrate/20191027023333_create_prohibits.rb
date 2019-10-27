class CreateProhibits < ActiveRecord::Migration[5.2]
  def change
    create_table :prohibits do |t|

      t.string :prohibit_words
      t.timestamps
    end
  end
end
