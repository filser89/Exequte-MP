class TrainingSession < ApplicationRecord
  validates :begins_at, presence: true
  belongs_to :training
  has_many :bookings
  has_many :users, through: :bookings



  def standard_hash
    {
      id: id,
      begins_at: begins_at,
      calories: training.calories,
      duration: training.duration,
      capacity: training.capacity,
      name: training.localize_name,
      class_type: training.class_type.kind,
      bookable: can_book?,
      begins_in_days: begins_in_days
    }
  end

  def begins_in_days
    (begins_at.midnight.to_datetime - DateTime.now.midnight).to_i

  end

  def can_book?
    training.capacity > bookings.where(cancelled: false).count
  end
end
