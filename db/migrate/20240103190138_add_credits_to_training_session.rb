class AddCreditsToTrainingSession < ActiveRecord::Migration[6.0]
  def change
    add_column :training_sessions, :credits, :integer
    add_column :trainings, :credits, :integer
    add_column :bookings, :credits, :integer
    add_column :users, :credits, :integer
  end
end
