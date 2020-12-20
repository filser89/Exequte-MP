class AddAttributesToMemberships < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :name, :string, null: false
    add_column :memberships, :cn_name, :string, null: false
    add_column :memberships, :duration, :integer, null: false
  end
end
