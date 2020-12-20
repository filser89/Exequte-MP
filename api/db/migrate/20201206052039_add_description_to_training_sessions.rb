class AddDescriptionToTrainingSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :training_sessions, :description, :string, null: false
    add_column :training_sessions, :cn_description, :string, null: false
  end
end
