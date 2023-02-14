class Membership < ApplicationRecord
  include WxPayable
  validates :name, presence: true
  validates :cn_name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  monetize :price_cents
  belongs_to :membership_type
  belongs_to :user
  has_many :bookings
  has_many :training_sessions, through: :bookings
  default_scope -> { where(destroyed_at: nil) }
  scope :settled, -> {where(payment_status: "paid")}



  def booking_hash
    h = standard_hash
    h[:start_date] = DateTimeService.date_d_m_y(start_date)
    h[:end_date] = DateTimeService.date_d_m_y(end_date)
    h
  end

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

  def settled?
    payment_status == "paid"
  end

  def change_end_date(days)
    self.end_date = self.end_date.ago(-days.days)
  end
end
