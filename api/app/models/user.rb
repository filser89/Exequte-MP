class User < ApplicationRecord
  DEFAULT_NAME = "#{Rails.application.class.module_parent} User".freeze
  ACTIVITY_LEVELS = [nil, "worker", "desk"]
  validates :profession_activity_level, inclusion: { in: ACTIVITY_LEVELS }
  serialize :music_styles, Array
  has_one :body
  has_many :bookings
  has_many :training_sessions, through: :bookings
  has_many :memberships
  has_many :membership_types, through: :memberships


  before_validation :set_defaults

  def token
    TokenService.encode('user' => id)
  end

  def index_hash
    h = standard_hash
    # Add new attributes here as shown below:
    # h[:images] = images
    return h
  end

  def show_hash
    h = standard_hash
    # Add new attributes here as shown below:
    # h[:images] = images
    return h
  end

  def standard_hash
    {
      id: id,
      name: name,
      city: city,
      wechat: wechat,
      phone: phone,
      email: email,
      gender: gender,
      admin: admin
    }
  end

  def prices
    {
      1 => 'price_1_cents',
      2 => calc_standard_price,
      3 => 'price_1_cents'
    }
  end

  private

  def calc_standard_price
    return 'price_1_cents' if average_attendence <= 1

    return "price_#{average_attendence}_cents" if (2..6).include?(average_attendence)

    'price_7_cents'
  end

  def average_attendence
    attended = bookings.where(attended: true)
    range = 28.days.ago..Date.yesterday
    count = attended.count { |a| range.include?(a.training_session.begins_at) }
    count / 4
  end


  def set_defaults
    self.name = DEFAULT_NAME if self.name.blank?
  end
end
