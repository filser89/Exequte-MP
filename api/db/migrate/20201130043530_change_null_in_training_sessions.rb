class ChangeNullInTrainingSessions < ActiveRecord::Migration[6.0]
  def change
    change_column_null :training_sessions, :begins_at, false
  end
end
