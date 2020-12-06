class AddAttributesToTrainingSessions < ActiveRecord::Migration[6.0]
  def change
    add_column :training_sessions, :duration, :integer, null: false
    add_column :training_sessions, :capacity, :integer, null: false
    add_column :training_sessions, :calories, :integer
    add_column :training_sessions, :name, :string, null: false
    add_column :training_sessions, :cn_name, :string, null: false
    add_monetize :training_sessions, :price_1
    add_monetize :training_sessions, :price_2
    add_monetize :training_sessions, :price_3
    add_monetize :training_sessions, :price_4
    add_monetize :training_sessions, :price_5
    add_monetize :training_sessions, :price_6
    add_monetize :training_sessions, :price_7
  end
end
