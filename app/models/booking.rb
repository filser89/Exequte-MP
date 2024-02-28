class Booking < ApplicationRecord
  include WxPayable
  include MessageScheduler
  BOOKING_OPTIONS = [nil, 'free', 'drop-in', 'membership', 'voucher', 'class-pack', 'credits']
  PAYMENT_OPTIONS = ['paid', 'none', 'pending']
  SETTLED_PAYMENTS = %w[paid none]
  monetize :price_cents
  belongs_to :user
  belongs_to :training_session
  belongs_to :membership, optional: true
  belongs_to :hrm, optional: true
  belongs_to :hrm_assignment, class_name: 'HrmAssignment', optional: true

  has_one :heart_rate_data, dependent: :destroy
  has_one_attached :heart_rate_data_picture

  validates :booked_with, inclusion: BOOKING_OPTIONS
  after_create  :notify_new
  # after_update :unassign_hrm_to_training_session, if: :cancelled_changed?


  default_scope -> { where(destroyed_at: nil) }
  scope :settled, -> { where(payment_status: SETTLED_PAYMENTS) }
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
  scope :today, -> {with_ts.settled.active.references(:training_sessions)
                             .where('training_sessions.begins_at >= ? and training_sessions.begins_at <= ?', DateTime.now.midnight, Time.now.end_of_day)}

  scope :with_hrm, -> { where.not(hrm_id: nil) }

  def settled?
    payment_status.in?(SETTLED_PAYMENTS)
  end

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

  def hrm_hash
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
      user_id: user.id,
      date: training_session.begins_at,
      training_session_id: training_session.id,
      training: training_session.localize_name,
      booked_with: booked_with,
      attended: attended,
      price: price,
      can_cancel: can_cancel?,
      first_booking: first_booking?,
      has_injury: has_injury?,
      status: status,
      status_locale: localize_status,
      hrm: hrm
    }
  end

  def can_cancel?
    DateTime.now < training_session.begins_at && !cancelled
  end

  def has_injury?
    # if only active booking in system, then its first booking
    if (user && user.injury && user.injury != "" && user.injury != " ")
      return true
    end
    return false
  end

  def first_booking?
    # if only active booking in system, then its first booking
    Booking.for(user).active.size == 1 ? true : false
  end

  def cancelled_on_time?
    need_to_cancel_before = training_session.begins_at.advance(:hours => -training_session.cancel_before)
    cancelled_at.before? need_to_cancel_before
  end

  def status
    return 'completed' if attended
    return 'cancelled' if cancelled
    DateTime.now < training_session.begins_at ? 'new' : 'no show'
  end

  def class_time
    training_session&.begins_at
  end

  def class_name
    training_session&.name
  end

  def subtitle
    training_session&.subtitle
  end

  def client_first_name
    p "===========================USER", user
    user&.first_name
  end

  def client_last_name
    user&.last_name
  end

  def booking_reminder_notification_time
    training_session.begins_at.midnight - 1.day + 20.hours
  end

  def instructor
    training_session&.instructor&.first_name
  end

  def localize_status
    status_field = self.status
    case status_field
    when "completed"
      return I18n.locale == :'zh-CN' ? "上课了" : "completed"
    when "cancelled"
      return I18n.locale == :'zh-CN' ? "取消了" : "cancelled"
    when "new"
      return I18n.locale == :'zh-CN' ? "即将" : "new"
    when "no show"
      return I18n.locale == :'zh-CN' ? "没上课了" : "no show"
    end
  end

  def assign_hrm_to_training_session
    # Check if an HRM is already assigned to this booking
    return if hrm
    available_hrms = training_session.available_hrms
    puts "Available HRMS:"
    available_hrms.each do |hrm|
      puts hrm.name
    end

    if available_hrms.any?
      hrm = available_hrms.first
      puts "Inside #{hrm.name}"
      hrm_assignment = HrmAssignment.create(hrm: hrm, training_session: training_session, assigned: true)
      update(hrm: hrm, hrm_assignment: hrm_assignment)
    end
  end


  def unassign_hrm_to_training_session
    # Check if an HRM is assigned to this booking
    return unless hrm_assignment

    begin
      # Save the current hrm_assignment ID
      hrm_assignment_id = hrm_assignment.id

      # Set the hrm_assignment to nil
      self.hrm_assignment = nil

      # Save the booking to disassociate the hrm_assignment
      save!

      # Destroy the original HrmAssignment record
      HrmAssignment.destroy(hrm_assignment_id)
    rescue StandardError => e
      puts "Error while unassigning HRM: #{e.message}"
    end
  end

  def set_heart_rate_data(force)
    begin
    start_timestamp = training_session.begins_at - 8.hours
    end_timestamp = training_session.ends_at - 8.hours
    bandId = hrm.id
    # Create an instance of HrmService
    hrm_service = HrmService.new
    # Call the fetch_heart_rate_data method
    gender = user&.gender.present? && ["Male", "Female"].include?(user&.gender) ? user&.gender : "Female"
    weight = user&.current_weight || 60
    age = user&.age || 30

    puts "setting the heart rate data (values) for user #{user&.workout_name} gender: #{gender},weight: #{weight}, age:#{age}"
    puts "start_timestamp: #{start_timestamp},end_timestamp: #{end_timestamp}"

    # Check if heart rate data already exists for this booking and user (unless flag force = true, in that case force refresh)
    if heart_rate_data.nil? || force == true
      puts "calling api"
      heart_rate_data = hrm_service.fetch_heart_rate_values(
        bandId,
        start_timestamp,
        end_timestamp,
        gender,
        weight,
        age
      )

      if heart_rate_data["error"]
        puts "HRM api returned error, not saving in DB"
        puts "#{heart_rate_data["error"]}"
      else
        heart_rate_data_attributes = {
          hrm_data_raw: heart_rate_data['hrm_data_raw'],
          hrm_data: heart_rate_data['hrm_data']
        }
        # Create and associate HeartRateData with Booking
        self.create_heart_rate_data!(heart_rate_data_attributes)
        save!
      end
    end
    rescue => e
      puts "error saving heart rate data"
      puts e
    end
  end
end

