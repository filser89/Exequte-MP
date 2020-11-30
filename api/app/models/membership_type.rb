class MembershipType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :cn_name, presence: true, uniqueness: true
  validates :duration, presence: true
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  has_many :memberships
  has_many :users, through: :memberships
end
