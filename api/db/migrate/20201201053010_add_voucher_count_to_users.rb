class AddVoucherCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :voucher_count, :integer, default: 5, null: false
  end
end
