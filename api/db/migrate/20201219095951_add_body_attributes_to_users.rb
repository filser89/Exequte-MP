class AddBodyAttributesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :height, :integer
    add_column :users, :current_weight, :integer
    add_column :users, :current_body_fat, :integer
    add_column :users, :current_shapes, :string
    add_column :users, :target, :string
    add_column :users, :target_weight, :integer
    add_column :users, :target_body_fat, :integer
    add_column :users, :target_shapes, :string
  end
end
