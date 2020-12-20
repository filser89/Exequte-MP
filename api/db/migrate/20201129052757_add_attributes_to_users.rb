class AddAttributesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :workout_name, :string
    add_column :users, :emergency_name, :string
    add_column :users, :emergency_phone, :string
    add_column :users, :birthday, :date
    add_column :users, :nationality, :string
    add_column :users, :profession, :string
    add_column :users, :profession_activity_level, :string
    add_column :users, :favorite_song, :string
    add_column :users, :music_styles, :string
    add_column :users, :sports, :string
    add_column :users, :favorite_food, :text
  end
end
