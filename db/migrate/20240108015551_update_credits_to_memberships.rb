class UpdateCreditsToMemberships < ActiveRecord::Migration[6.0]
  def change
    change_column :training_sessions, :credits, :integer, default: 20
    change_column :users, :credits, :integer, default: 20
    change_column :memberships, :credits, :integer, default: 20
    change_column :membership_types, :credits, :integer, default: 20
  end
end
