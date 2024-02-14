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
  has_many_attached :photos
  has_many_attached :videos
  has_many :bookings
  has_many :users, through: :bookings
  has_and_belongs_to_many :workouts
  has_many :hrm_assignments
  has_many :hrms, through: :hrm_assignments
  has_one_attached :poster_photo
  has_many :training_session_rankings
  has_many :ranked_users, through: :training_session_rankings, source: :user

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
    h[:photos_urls] = photos_service_urls
    h[:videos_urls] = videos_service_urls
    h
  end

  def photos_service_urls
    photos.map { |photo| photo.service_url }
  end

  def videos_service_urls
    videos.map { |video| video.service_url }
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

  def show_workout_ts
    h = standard_hash
    if workouts.present?
      puts "training session has associated workout"
      h[:workout] = show_workout
    end
    h
  end

  def show_assignment_ts
    begin
      if poster_photo.attached?
        poster_photo_url = poster_photo.service_url
      else
        poster_photo_url = training.poster_photo.attached? ? training.poster_photo.service_url : ""
      end
    rescue => e
      puts e
    end
    {
      id: id,
      calories: calories,
      duration: duration,
      instructor_name: instructor.get_coach_name,
      capacity: capacity,
      name: localize_name,
      subtitle: localize('subtitle'),
      class_type: training.class_type.kind,
      from: DateTimeService.time_24_h_m(begins_at),
      to: DateTimeService.time_24_h_m(begins_at + duration.minutes),
      date_locale: localize_date_long,
      date_locale_short: localize_date_short,
      begins_at: begins_at,
      location: location,
      hrm_assignments: hrm_assignments_with_user,
      poster_photo: poster_photo_url || "",
      current_block: current_block
    }
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
      instructor_name: instructor.get_coach_name,
      training_id: training.id,
      date: DateTimeService.date_long_wd_m_d_y(begins_at),
      date_locale: localize_date_long,
      date_locale_short: localize_date_short,
      price: calc_price,
      credits: credits.nil? ? 20 : credits, # Check if credits is nil and set default to 20
      dates_array: dates_for_membership,
      membership_date: begins_at.midnight,
      enforce_cancellation_policy: enforce_cancellation_policy,
      note: note,
      late_booking_minutes: late_booking_minutes,
      location: location,
      current_block: current_block
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

  def show_workout
    if workouts.present?
      puts "training session has associated workout"
      current_workout = workouts[0]
      return current_workout.show_hash_blocks
    end
  end

  # ul do
  #   hrm_assignments = HrmAssignment.where(training_session_id: training_session.id, assigned: true)
  #   hrm_assignments.each do |hrm_assignment|
  #     hrm = Hrm.find(hrm_assignment.hrm_id)
  #     booking = training_session.bookings.find_by(hrm_assignment: hrm_assignment)
  #     li do
  #       "#{hrm.name} (Assigned to: #{booking.user.full_name if booking})"
  #     end
  #   end

  def hrm_assignments_with_user
    hrm_assignments.where(assigned: true).map do |hrm_assignment|
      hrm = hrm_assignment.hrm
      booking = bookings.find_by(hrm_assignment: hrm_assignment)
      avatar_url = nil
      if booking && booking.user && booking.user.avatar && booking.user.avatar.respond_to?('attached?') && booking.user.avatar.attached?
        avatar_url = booking&.user&.avatar.service_url
      end
      {
        hrm_name: hrm.name,
        hrm_display_name: hrm.display_name,
        assigned_to: booking&.user&.workout_name,
        user: {
          gender: booking&.user&.gender.present? && ["Male", "Female"].include?(booking&.user.gender) ? booking&.user.gender : "Female",
          weight: booking&.user&.current_weight || 60,
          age: booking&.user&.age || 30,
          workout_name: booking&.user&.workout_name,
          first_name:  booking&.user&.first_name,
          last_name: booking&.user&.last_name,
          avatar: avatar_url,
        },
        assigned: hrm_assignment.assigned
      }
    end
  end

  def workout_current
    if workouts.present?
      puts "training session has associated workout"
      current_workout = workouts[0]
      return current_workout
    end
  end

  def available_hrms
    assigned_hrms = hrm_assignments.where(assigned: true).pluck(:hrm_id)
    Hrm.where.not(id: assigned_hrms)
  end

  def ends_at
    self.begins_at + self.duration.minutes
  end

  def set_ranking
    begin
      puts "inside set ranking"
      if bookings.any?
        # Create a hash to store user_id => calories_burned mapping
        calories_burned_map = {}
        bookings&.settled&.each do |booking|
          puts "about to re-set heart rate data for every booking"
          booking.set_heart_rate_data(true)
          heart_rate_data = booking.heart_rate_data
          if heart_rate_data.present? && heart_rate_data.hrm_data.present?
            # Extract user_id and calories_burned values and store in the map
            user_id = booking.user_id
            calories_burned = heart_rate_data.hrm_data['calories_burned']
            calories_burned_map[user_id] = calories_burned if calories_burned.present?
          else
            puts "no heart-rate data found, check db errors"
          end
        end

        puts "Content of calories_burned_map:"
        puts calories_burned_map.inspect
        # Sort the map based on calories_burned in descending order
        sorted_calories_burned_map = calories_burned_map.sort_by { |_, value| value }.reverse.to_h

        puts "here"
        if sorted_calories_burned_map
          # Update user rankings based on the sorted map
          sorted_calories_burned_map.each_with_index do |(user_id, calories_burned), index|
            ranking_entry = training_session_rankings.find_or_initialize_by(user_id: user_id)
            ranking_entry.update(ranking: index + 1, calories: calories_burned)
          end
          puts "here2"
        end
      end
      rescue => e
      puts e
      puts "something went wrong setting ranking"
      end
  end


end
