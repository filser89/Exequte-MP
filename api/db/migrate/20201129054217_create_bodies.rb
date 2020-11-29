class CreateBodies < ActiveRecord::Migration[6.0]
  def change
    create_table :bodies do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :height
      t.integer :current_weight
      t.integer :current_fat_percentage
      t.string :current_shapes
      t.string :target
      t.integer :target_weight
      t.integer :target_fat_percentage
      t.string :target_shapes

      t.timestamps
    end
  end
end
