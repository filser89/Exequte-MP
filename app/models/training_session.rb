class TrainingSession < ApplicationRecord
  monetize :price_1_cents, :price_2_cents, :price_3_cents, :price_4_cents, :price_5_cents, :price_6_cents, :price_7_cents
  serialize :queue, Array
  validates :begins_at, presence: true
  validates :name, presence: true
  validates :cn_name, presence: true
  validates :description, presence: true
  validates :cn_description, presence: true
  validates :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :capacity, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  belongs_to :training
  belongs_to :instructor, class_name: "User", foreign_key: :user_id
  has_many :bookings
  has_many :users, through: :bookings
  default_scope -> { where(destroyed_at: nil) }


  def upcoming_hash
    h = show_hash
    h[:date] = DateTimeService.date_wd_d_m(begins_at)
    h
  end

  def history_hash
    h = show_hash
    h[:date] = DateTimeService.date_d_m_y(begins_at)
    h
  end

  def show_hash
    h = standard_hash
    h[:description] = localize_description
    h[:cancel_before] = cancel_before
    h
  end

  def date_list_hash
    h = standard_hash
    h[:date] = DateTimeService.date_d_m_wd(begins_at)
    h
  end

  def attendance_hash
    h = standard_hash
    h[:date] = DateTimeService.date_wd_d_m(begins_at)
    h[:bookings] = bookings.map(&:attendance_hash)
    h
  end

  def standard_hash
    h = {
      id: id,
      begins_at: begins_at,
      calories: calories,
      duration: duration,
      capacity: capacity,
      name: localize_name,
      class_type: training.class_type.kind,
      bookable: can_book?,
      queue: queue.map(&:standard_hash),
      from: DateTimeService.time_24_h_m(begins_at),
      to: DateTimeService.time_24_h_m(begins_at + duration.minutes),
      instructor_id: instructor.id,
      training_id: training.id,
      date: DateTimeService.date_long_wd_m_d_y(begins_at),
      dates_array: dates_for_membership,
      membership_date: begins_at.midnight
    }
    h[:image_url] =  training.photo.service_url if training.photo.attached?
    h
  end

  def dates_for_membership
    (DateTime.now.midnight..begins_at).to_a.reverse.map { |d| DateTimeService.date_y_m_d(d) }
  end

  def begins_in_days
    (begins_at.midnight.to_datetime - DateTime.now.midnight).to_i
  end

  def can_book?
    capacity > bookings.where(cancelled: false).size
  end

  def localize_description
    I18n.locale == :'zh-CN' ? cn_description : description
  end
end
