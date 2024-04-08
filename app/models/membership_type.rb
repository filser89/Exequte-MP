class MembershipType < ApplicationRecord
  monetize :price_cents
  validates :name, presence: true, uniqueness: true
  validates :cn_name, presence: true, uniqueness: true
  validates :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  has_many :memberships
  has_many :users, through: :memberships
  has_many :membership_trainings
  has_many :trainings, through: :membership_trainings, source: :training
  accepts_nested_attributes_for :membership_trainings
  default_scope -> { where(destroyed_at: nil) }
  scope :active, -> {where(active: true)}
  scope :classpack, -> {where(is_class_pack: true)}
  scope :not_classpack, -> {where(is_class_pack: false)}
  scope :trial, -> {where(is_trial: true)}
  scope :not_trial, -> {where(is_trial: false)}
  scope :with_trainings, -> { includes(:trainings) }
  scope :is_limited, -> {where(is_limited: true)}
  scope :is_not_limited, -> {where(is_limited: false)}
  scope :order_by_credits, -> { order('credits DESC')}
  scope :order_by_name, -> { order('name ASC')}
  scope :new_studio, -> {where('updated_at >= ?', '2024-03-01 00:00:00 +0800'
  )}
  scope :has_credits_or_unlimited, -> {where('credits >= ? or is_unlimited = ?', 0, true
  )}

  def standard_hash
    {
      id: id,
      name: localize_name,
      duration: duration,
      price: price.to_i,
      credits: credits,
      vouchers: vouchers,
      book_before: book_before,
      description: localize_description,
      is_class_pack: is_class_pack,
      bookings_per_day: bookings_per_day,
      is_trial: is_trial,
      unlimited: unlimited?,
      settings: settings,
      is_unlimited: is_unlimited
    }
  end

  def unlimited?
    if !bookings_per_day || bookings_per_day == -1
      return true
    else
      return false
    end
  end

  def title_summary
    "#{name} - #{credits} credits - #{duration} days - #{price.to_i}元 - (#{book_before} days advance)"
  end

end
