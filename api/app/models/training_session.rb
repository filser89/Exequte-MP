class TrainingSession < ApplicationRecord
  monetize :price_1_cents, :price_2_cents, :price_3_cents, :price_4_cents, :price_5_cents, :price_6_cents, :price_7_cents
  serialize :queue, Array
  validates :begins_at, presence: true
  belongs_to :training
  belongs_to :instructor, class_name: "User", foreign_key: :user_id
  has_many :bookings
  has_many :users, through: :bookings

  def show_hash
    h = standard_hash
    h[:description] = localize_description
  end

  def standard_hash
    {
      id: id,
      begins_at: begins_at,
      calories: calories,
      duration: duration,
      capacity: capacity,
      name: localize_name,
      class_type: training.class_type.kind,
      bookable: can_book?,
      begins_in_days: begins_in_days,
      queue: queue.map(&:standard_hash)
      # can_book_with: {'drop-in', 'voucher', 'membership' or membership: membership_hash}'}
    }
  end

  def begins_in_days
    (begins_at.midnight.to_datetime - DateTime.now.midnight).to_i
  end

  def can_book?
    capacity > bookings.where(cancelled: false).count
  end

end
