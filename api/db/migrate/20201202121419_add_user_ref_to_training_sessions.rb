class AddUserRefToTrainingSessions < ActiveRecord::Migration[6.0]
  def change
    add_reference :training_sessions, :user, null: false, foreign_key: true
  end
end
