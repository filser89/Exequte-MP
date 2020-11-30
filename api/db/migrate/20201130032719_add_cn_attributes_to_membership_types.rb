class AddCnAttributesToMembershipTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_types, :cn_name, :string
  end
end
