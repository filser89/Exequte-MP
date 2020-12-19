class AddSmoothieToMemberships < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :smoothie, :boolean, null: false
  end
end
