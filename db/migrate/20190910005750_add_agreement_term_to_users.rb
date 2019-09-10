class AddAgreementTermToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :agreement_term, :string
  end
end
