class AddTestToTrainingSession < ActiveRecord::Migration[6.0]
  def change
    add_column :training_sessions, :is_fitness_test, :boolean, default: false
    add_column :trainings, :is_fitness_test, :boolean, default: false
    add_column :bookings, :is_fitness_test, :boolean, default: false
  end
end
