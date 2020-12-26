class Membership < ApplicationRecord
  validates :name, presence: true
  validates :cn_name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  monetize :price_cents
  belongs_to :membership_type
  belongs_to :user
  has_many :bookings
  has_many :training_sessions, through: :bookings


  def standard_hash
    {
      id: id,
      name: localize_name,
      price: price.to_i,
      start_date: DateTimeService.date_m_d_y(start_date),
      end_date: DateTimeService.date_m_d_y(end_date),
      smoothie: smoothie
    }
  end
end
