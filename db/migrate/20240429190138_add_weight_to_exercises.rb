class AddWeightToExercises < ActiveRecord::Migration[6.0]
  def change
    add_column :exercises_workouts, :weight, :integer
    add_column :logged_exercises, :weight, :integer
    add_column :logged_workouts, :validation_status, :string
    add_column :logged_workouts, :validation_request_at, :datetime
  end
end
