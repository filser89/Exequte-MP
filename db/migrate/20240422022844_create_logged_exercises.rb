class CreateLoggedExercises < ActiveRecord::Migration[6.0]
  def change
    create_table :logged_exercises do |t|
      t.references :logged_workout, foreign_key: true
      t.integer :time_limit
      t.string :format
      t.integer :sets
      t.string :block
      t.string :reps_gold
      t.string :reps_silver
      t.string :reps_bronze
      t.integer :batch_index
      t.integer :order
      t.string :reps
      t.string :comments
      t.references :exercise, foreign_key: true
      t.timestamps
    end
  end
end
