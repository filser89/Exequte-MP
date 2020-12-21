class User < ApplicationRecord
  DEFAULT_NAME = "#{Rails.application.class.module_parent} User".freeze
  ACTIVITY_LEVELS = [nil, "worker", "desk"].freeze
  TARGETS = [nil, "lose", "gain", "maintain"].freeze
  validates :profession_activity_level, inclusion: { in: ACTIVITY_LEVELS }
  validates :target, inclusion: { in: TARGETS}
  # serialize :music_styles, Array
  has_one :body
  has_many :bookings
  has_many :training_sessions, through: :bookings
  has_many :training_sessions_as_instructor, class_name: "TrainingSession"
  has_many :memberships
  # has_many :membership_types, through: :memberships
  has_one_attached :instructor_photo
  has_one_attached :avatar

  before_validation :set_defaults

  def token
    TokenService.encode('user' => id)
  end

  def info_hash
    standard_hash
  end

  def index_hash
    h = standard_hash
    # Add new attributes here as shown below:
    # h[:images] = images
    return h
  end

  def show_hash
    h = standard_hash
    h[:workout_name] = workout_name
    h[:emergency_name] = emergency_name
    h[:emergency_phone] = emergency_phone
    h[:birthday] = birthday
    h[:nationality] = nationality
    h[:profession] = profession
    h[:profession_activity_level] = profession_activity_level
    h[:favorite_song] = favorite_song
    h[:music_styles] = music_styles
    h[:sports] = sports
    h[:favorite_food] = favorite_food
    h[:instructor] = instructor
    h[:instructor_bio] = instructor_bio
    h[:height] = height
    h[:current_weight] = current_weight
    h[:current_body_fat] = current_body_fat
    h[:current_shapes] = current_shapes
    h[:target] = target
    h[:target_weight] = target_weight
    h[:target_body_fat] = target_body_fat
    h[:target_shapes] = target_shapes
    h[:recommended_bmr] = recommended_bmr
    h[:recommended_kcals] = recommended_kcals
    h[:carb_prot_fat] = carb_prot_fat
    h[:average_attendence] = average_attendence
    h[:attended_classes] = attended_classes
    h[:memberships] = valid_memberships
    h[:avatar_url] = avatar.service_url if avatar.attached?
    h
  end

  def instructor_hash
    {
      first_name: first_name,
      last_name: last_name,
      bio: localize_instructor_bio,
      image_url: instructor_photo.service_url
    }
  end

  def standard_hash
    {
      id: id,
      name: name,
      first_name: first_name,
      last_name: last_name,
      city: city,
      wechat: wechat,
      phone: phone,
      email: email,
      gender: gender,
      admin: admin,
      voucher_count: voucher_count
    }
  end

  def recommended_bmr; end

  def recommended_kcals; end

  def carb_prot_fat; end

  def attended_classes
    bookings.where(attended: true).count
  end

  def valid_memberships
    memberships.where('end_date >= ?', DateTime.now.midnight)
  end

  def prices
    {
      1 => 'price_1_cents',
      2 => calc_standard_price,
      3 => 'price_1_cents'
    }
  end

  def use_voucher!
    self.voucher_count -= 1
    save
  end

  def return_voucher!
    self.voucher_count += 1
    save
  end

  def localize_instructor_bio
    I18n.locale == :'zh-CN' ? cn_instructor_bio : instructor_bio
  end

  private

  def calc_standard_price
    return 'price_1_cents' if average_attendence <= 1

    return "price_#{average_attendence}_cents" if (2..6).include?(average_attendence)

    'price_7_cents'
  end

  def average_attendence

    days_to_count = days_since_created < 28 ? days_since_created : 28

    attended = bookings.where(attended: true)
    range = days_to_count.days.ago..Date.yesterday
    count = attended.count { |a| range.include?(a.training_session.begins_at.to_datetime) }
    count / days_to_count * 7
  end

  def set_defaults
    self.name = DEFAULT_NAME if self.name.blank?
  end
end
