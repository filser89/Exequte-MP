class AddCancelBeforeToTrainingSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :training_sessions, :cancel_before, :integer, null: false
  end
end
