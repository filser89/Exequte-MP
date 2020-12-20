class AddClassKindToTrainingSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :training_sessions, :class_kind, :integer, null: false
  end
end
