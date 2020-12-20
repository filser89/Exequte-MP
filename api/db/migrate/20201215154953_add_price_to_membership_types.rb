class AddPriceToMembershipTypes < ActiveRecord::Migration[6.0]
  def change
    add_monetize :membership_types, :price
  end
end
