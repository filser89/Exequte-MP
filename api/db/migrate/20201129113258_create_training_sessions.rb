class CreateTrainingSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :training_sessions do |t|
      t.date :date
      t.time :time
      t.string :queue
      t.references :training, null: false, foreign_key: true

      t.timestamps
    end
  end
end
