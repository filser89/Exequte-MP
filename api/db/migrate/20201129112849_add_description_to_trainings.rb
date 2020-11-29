class AddDescriptionToTrainings < ActiveRecord::Migration[6.0]
  def change
    add_column :trainings, :description, :text
  end
end
