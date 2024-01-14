class AddLocationToTrainings < ActiveRecord::Migration[6.0]
  def change
    add_column :trainings, :location, :string
  end
end
