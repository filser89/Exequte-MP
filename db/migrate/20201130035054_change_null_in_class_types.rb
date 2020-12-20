class ChangeNullInClassTypes < ActiveRecord::Migration[6.0]
  def change
    change_column_null :class_types, :name, false
    change_column_null :class_types, :kind, false
    change_column_null :class_types, :cancel_before, false
  end
end
