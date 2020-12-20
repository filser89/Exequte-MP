class AddDefaultFalseToCancelledInBookings < ActiveRecord::Migration[6.0]
  def change
    change_column_null :bookings, :cancelled, false
    change_column_default :bookings, :cancelled, from: true, to: false
  end
end
