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
  has_and_belongs_to_many :workouts
  default_scope -> { where(destroyed_at: nil) }
  scope :limited, -> {where(is_limited: true)}
  scope :not_limited, -> {where(is_limited: false)}

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
    h[:date_locale] = localize_date
    h
  end

  def attendance_hash
    h = standard_hash
    h[:date] = DateTimeService.date_wd_d_m(begins_at)
    h[:date_locale] = localize_date
    h[:bookings] = bookings.settled.where(cancelled: false).map(&:attendance_hash)
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
      subtitle: localize('subtitle'),
      class_type: training.class_type.kind,
      bookable: can_book?,
      queue: User.where(id: queue).map(&:standard_hash),
      from: DateTimeService.time_24_h_m(begins_at),
      to: DateTimeService.time_24_h_m(begins_at + duration.minutes),
      instructor_id: instructor.id,
      training_id: training.id,
      date: DateTimeService.date_long_wd_m_d_y(begins_at),
      date_locale: localize_date_long,
      date_locale_short: localize_date_short,
      price: calc_price,
      dates_array: dates_for_membership,
      membership_date: begins_at.midnight,
      enforce_cancellation_policy: enforce_cancellation_policy,
      note: note,
      late_booking_minutes: late_booking_minutes
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
    capacity > bookings&.settled.where(cancelled: false)&.size
  end

  def localize_description
    I18n.locale == :'zh-CN' ? cn_description : description
  end

  def localize_date
    I18n.locale == :'zh-CN' ? DateTimeService.date_d_m_wd_zh(begins_at)  : DateTimeService.date_d_m_wd(begins_at)
  end
  def localize_date_short
    I18n.locale == :'zh-CN' ? DateTimeService.date_d_m_wd_zh(begins_at)  : DateTimeService.date_wd_d_m(begins_at)
  end
  def localize_date_long
    I18n.locale == :'zh-CN' ? DateTimeService.date_long_wd_m_d_y_zh(begins_at)  : DateTimeService.date_long_wd_m_d_y(begins_at)
  end

  # returns a name with subtile if there is a subtile or just a name
  def full_name
    (self.localize_name ? self.localize_name : self.name)  + "#{self.subtitle.present? ? (': ' + self.localize('subtitle')) : ''}"
  end

  def self.notify_queue(training_session)
    # User.where(id: training_session.queue, admin: true).each do |u| # TEST MODE
    User.where(id: training_session.queue).each do |u|
      puts "NOTIFICATION FOR QUEUE: USER #{u.full_name}"
      # Not sure what obj_hash does so can be an error next line
      obj_hash  = {id: training_session.id, model: training_session.model_name.name}
      note_params = {
        openid: u.oa_open_id,
        unionid: u.union_id, # needed to retrieve oa_open_id if it is not present
        pagepath: "pages/class-info/class-info?sessionId=#{training_session.id}&instructorId=#{training_session.instructor.id}",
        ts_name: training_session.full_name,
        # ts_date: DateTimeService.date_d_m_y(training_session.begins_at),
        ts_time: "#{DateTimeService.date_d_m_y(training_session.begins_at)} #{DateTimeService.time_12_h_m(training_session.begins_at)}"
      }
      wx_params = WechatNotifier.notify_queue(note_params)
      WechatWorker.perform_async('notify_queue', obj_hash, wx_params)
    end
  end

  def self.notify_cancellation_single(booking)
    puts "=======INSIDE NOTIFY CANCELLATION SINGLE======="
      begin
        puts "NOTIFICATION FOR CANCELLATION: USER #{booking.user.full_name}"
        puts "booking.user.oa_open_id:#{booking.user.oa_open_id}"
        puts "booking.user.union_id:#{booking.user.union_id}"
        # Not sure what obj_hash does so can be an error next line
        obj_hash  = {id: booking.training_session.id, model:  booking.training_session.model_name.name}
        note_params = {
          openid: booking.user.oa_open_id,
          unionid: booking.user.union_id, # needed to retrieve oa_open_id if it is not present
          pagepath: "pages/class-info/class-info?sessionId=#{booking.training_session.id}&instructorId=#{booking.training_session.instructor.id}",
          ts_name: booking.training_session.full_name,
          phone: booking.user.phone,
          # ts_date: DateTimeService.date_d_m_y(training_session.begins_at),
          ts_time: "#{DateTimeService.date_d_m_y(booking.training_session.begins_at)} #{DateTimeService.time_12_h_m(booking.training_session.begins_at)}"
        }
        wx_params = WechatNotifier.trainingsession_cancel(note_params)
        puts "about to send sms notification"
        sms_resp = SmsNotifier.trainingsession_cancel(note_params)
        WechatWorker.perform_async('trainingsession_cancel', obj_hash, wx_params)
        #WechatNotifier.notify!(wx_params)
      rescue => exceptionThrown
        puts exceptionThrown
        puts  "===================SOMETHING WENT WRONG, ABORT========================="
    end
  end

  def self.notify_cancellation(training_session)
    puts "=======INSIDE NOTIFY CANCELLATION======="
    training_session.bookings.settled.each do | booking|
      begin
        puts "NOTIFICATION FOR CANCELLATION: USER #{booking.user.full_name}"
        puts "booking.user.oa_open_id:#{booking.user.oa_open_id}"
        puts "booking.user.union_id:#{booking.user.union_id}"
        # Not sure what obj_hash does so can be an error next line
        obj_hash  = {id: training_session.id, model: training_session.model_name.name}
        note_params = {
          openid: booking.user.oa_open_id,
          unionid: booking.user.union_id, # needed to retrieve oa_open_id if it is not present
          pagepath: "pages/class-info/class-info?sessionId=#{training_session.id}&instructorId=#{training_session.instructor.id}",
          ts_name: training_session.full_name,
          phone: booking.user.phone,
          # ts_date: DateTimeService.date_d_m_y(training_session.begins_at),
          ts_time: "#{DateTimeService.date_d_m_y(training_session.begins_at)} #{DateTimeService.time_12_h_m(training_session.begins_at)}"
        }
        wx_params = WechatNotifier.trainingsession_cancel(note_params)
        #puts "about to send sms notification"
        #sms_resp = SmsNotifier.trainingsession_cancel(note_params)
        WechatWorker.perform_async('trainingsession_cancel', obj_hash, wx_params)
      rescue => exceptionThrown
        puts exceptionThrown
        puts  "===================SOMETHING WENT WRONG, ABORT========================="
      end
    end
  end

  def calc_price
    price_7_cents ? price_7_cents / 100 : 0
  end
end
