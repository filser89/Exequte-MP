class AddPriceToMemberships < ActiveRecord::Migration[6.0]
  def change
    add_monetize :memberships, :price
  end
end
