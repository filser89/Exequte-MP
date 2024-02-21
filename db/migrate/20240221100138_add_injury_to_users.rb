class AddInjuryToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :injury, :string
    change_column :users, :credits, :integer, default: 0
  end
end
