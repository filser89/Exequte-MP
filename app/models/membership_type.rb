class MembershipType < ApplicationRecord
  monetize :price_cents
  validates :name, presence: true, uniqueness: true
  validates :cn_name, presence: true, uniqueness: true
  validates :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  has_many :memberships
  has_many :users, through: :memberships
  default_scope -> { where(destroyed_at: nil) }
  scope :active, -> {where(active: true)}


  def standard_hash
    {
      id: id,
      name: localize_name,
      duration: duration,
      price: price.to_i
    }
  end
end
