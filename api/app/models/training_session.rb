class TrainingSession < ApplicationRecord
  validates :begins_at, presence: true
  belongs_to :training
  has_many :bookings
  has_many :users, through: :bookings
end
