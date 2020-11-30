class ChangeNullInTrainings < ActiveRecord::Migration[6.0]
  def change
    change_column_null :trainings, :name, false
    change_column_null :trainings, :cn_name, false
    change_column_null :trainings, :duration, false
    change_column_null :trainings, :description, false
    change_column_null :trainings, :cn_description, false
    change_column_null :trainings, :capacity, false
  end
end
