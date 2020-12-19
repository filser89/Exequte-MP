class AddSmoothieToMembershipTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :membership_types, :smoothie, :boolean, null: false
  end
end
