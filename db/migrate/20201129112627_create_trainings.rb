class CreateTrainings < ActiveRecord::Migration[6.0]
  def change
    create_table :trainings do |t|
      t.string :name
      t.integer :calories
      t.integer :duration
      t.integer :capacity
      t.references :class_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
