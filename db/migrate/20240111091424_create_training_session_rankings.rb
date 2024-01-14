class CreateTrainingSessionRankings < ActiveRecord::Migration[6.0]
  def change
    create_table :training_session_rankings do |t|
      t.integer :ranking
      t.integer :calories
      t.references :training_session, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
