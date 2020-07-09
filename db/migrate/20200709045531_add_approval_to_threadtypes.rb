class AddApprovalToThreadtypes < ActiveRecord::Migration[5.2]
  def change
    add_column :threadtypes, :approval, :string,default:"free"
  end
end
