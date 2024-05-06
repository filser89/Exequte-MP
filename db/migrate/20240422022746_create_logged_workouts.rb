class CreateLoggedWorkouts < ActiveRecord::Migration[6.0]
  def change
    create_table :logged_workouts do |t|
      t.references :user, foreign_key: true
      t.references :workout, foreign_key: true
      t.references :booking, foreign_key: true  # Add this line to include the foreign key for the booking
      t.string :comments
      t.boolean :validated, null: false, default: false
      t.string :validated_by
      t.datetime :validated_at
      t.timestamps
    end
  end
end
