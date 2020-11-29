class Training < ApplicationRecord
  belongs_to :class_type
  has_many :training_sessions
  has_many :bookings, through: :training_sessions
end
