class Membership < ApplicationRecord
  belongs_to :membership_type
  belongs_to :user
  has_many :bookings
  has_many :training_sessions, through: :bookings

  def start_date
    ts = training_sessions.order(:begins_at).first
    ts.begins_at.midnight
  end

  def valid_till
    # -1 is minus 1 second so that the date valid_till displayed on frontend is last day of validity
    start_date + duration.days - 1
  end

  def standard_hash
    {
      id: id,
      name: localize_name
    }
  end
end
