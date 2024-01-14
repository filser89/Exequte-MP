class AddCreditAttributesToMemberships < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :credits, :integer
    add_column :membership_types, :credits, :integer
    add_column :memberships, :book_before,:integer
    add_column :membership_types, :book_before, :integer
    add_column :memberships, :settings, :jsonb, default: {}
    add_column :membership_types, :settings, :jsonb, default: {}
    add_column :memberships, :is_unlimited, :boolean, :default => false
    add_column :membership_types, :is_unlimited, :boolean, :default => false
  end
end
