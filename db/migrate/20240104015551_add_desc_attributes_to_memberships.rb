class AddDescAttributesToMemberships < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :description, :string
    add_column :membership_types, :description, :string
    add_column :memberships, :cn_description, :string
    add_column :membership_types, :cn_description, :string
  end
end
