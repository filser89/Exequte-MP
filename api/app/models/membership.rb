class Membership < ApplicationRecord
  monetize :price_cents
  belongs_to :membership_type
  belongs_to :user
  has_many :bookings
  has_many :training_sessions, through: :bookings

  def valid_till
    # -1 is minus 1 second so that the date valid_till displayed on frontend is last day of validity
    start_date + duration.days - 1
  end

  def standard_hash
    {
      id: id,
      name: localize_name,
      price: price.to_i,
      start_date: start_date,
      valid_till: valid_till
    }
  end
end
