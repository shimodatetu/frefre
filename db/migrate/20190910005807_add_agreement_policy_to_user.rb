class AddAgreementPolicyToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :agreement_policy, :string
  end
end
