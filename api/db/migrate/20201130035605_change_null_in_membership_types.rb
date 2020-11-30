class ChangeNullInMembershipTypes < ActiveRecord::Migration[6.0]
  def change
    change_column_null :membership_types, :name, false
    change_column_null :membership_types, :cn_name, false
    change_column_null :membership_types, :duration, false
  end
end
