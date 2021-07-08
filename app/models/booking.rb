class Booking < ApplicationRecord
  include WxPayable
  include MessageScheduler
  BOOKING_OPTIONS = [nil, 'free', 'drop-in', 'membership', 'voucher']
  monetize :price_cents
  belongs_to :user
  belongs_to :training_session
  belongs_to :membership, optional: true
  validates :booked_with, inclusion: BOOKING_OPTIONS
  after_create  :notify_new

  default_scope -> { where(destroyed_at: nil) }
  scope :settled, -> { where(payment_status: ['paid', 'none']) }
  scope :attended, -> { where(attended: true) }
  scope :with_ts, -> { includes(:training_session) }
  scope :history, -> {with_ts.settled.references(:training_sessions)
                      .where('training_sessions.begins_at <= ?', DateTime.now)
                      .order('training_sessions.begins_at DESC')}
  scope :upcoming, -> {with_ts.settled.references(:training_sessions)
                       .where('training_sessions.begins_at > ?', DateTime.now)
                       .order('training_sessions.begins_at ASC')}
  scope :for, -> (user) {where(user: user)}
  scope :cancelled, -> {where(cancelled: true).reorder('training_sessions.begins_at DESC')}
  scope :active, -> {where(cancelled: false)}


  def upcoming_hash
    h = show_hash
    h[:instructor_id] = training_session.instructor.id
    h[:session][:date] = DateTimeService.date_wd_d_m(training_session.begins_at)
    h
  end

  def history_hash
    h = show_hash
    h[:instructor_id] = training_session.instructor.id
    h[:session][:date] = DateTimeService.date_d_m_y(training_session.begins_at)
    # h[:status] = status
    h
  end

  def show_hash
    h = standard_hash
    h[:session] = training_session.show_hash
    h
  end

  def attendance_hash
    h = standard_hash
    h[:avatar_url] = user.avatar.service_url if user.avatar.attached?
    h
  end

  def standard_hash
    {
      id: id,
      first_name: user.first_name,
      last_name: user.last_name,
      date: training_session.begins_at,
      training_session_id: training_session.id,
      training: training_session.localize_name,
      booked_with: booked_with,
      attended: attended,
      price: price,
      can_cancel: can_cancel?,
      status: status
    }
  end

  def can_cancel?
    DateTime.now < training_session.begins_at && !cancelled
  end

  def cancelled_on_time?
    ((training_session.begins_at - cancelled_at) * 24).to_i > training_session.cancel_before
  end

  def status
    return 'completed' if attended
    return 'cancelled' if cancelled
    DateTime.now < training_session.begins_at ? 'new' : 'no show'
  end

  def class_time
    training_session.begins_at
  end

  def class_name
    training_session.name
  end

  def subtitle
    training_session.subtitle
  end

  def client_first_name
    user.first_name
  end

  def client_last_name
    user.last_name
  end

  def booking_reminder_notification_time
    training_session.begins_at.midnight - 1.day + 20.hours
  end


end
