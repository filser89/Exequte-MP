class CreateMembershipTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :membership_types do |t|
      t.string :name
      t.integer :duration

      t.timestamps
    end
  end
end
