class AddStartDateToMemberships < ActiveRecord::Migration[6.0]
  def change
    add_column :memberships, :start_date, :date, null: false
  end
end
