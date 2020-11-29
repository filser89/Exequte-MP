class ChangeAttributesInTrainingSessions < ActiveRecord::Migration[6.0]
  change_table :training_sessions do |t|
    t.remove :date, :time
    t.datetime :begins_at
  end
end
