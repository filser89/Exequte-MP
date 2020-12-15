class ChangeAttributesOfMemberships < ActiveRecord::Migration[6.0]
  def change
    remove_column :memberships, :duration, :integer
    add_column :memberships, :end_date, :datetime
    remove_column :memberships, :start_date, :date
    add_column :memberships, :start_date, :datetime
  end
end
