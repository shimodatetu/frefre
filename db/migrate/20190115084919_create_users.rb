class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :birth_year
      t.integer :birth_month
      t.integer :birth_day
      t.string :name
      t.string :email
      t.string :country
      t.string :gender
      t.binary :photo, :limit => 1.megabyte
      t.string :file_name
      t.string :profile_en
      t.string :profile_jp
      t.string :password_digest
      t.string :activation_digest
      # t.string :activation_token
      t.boolean :able_see, default: true
      t.string :agreement, default: false
      t.boolean :activated, default: false
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.integer :notice
      t.timestamps
    end
  end
end
