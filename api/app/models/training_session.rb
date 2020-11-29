class TrainingSession < ApplicationRecord
  belongs_to :training
  has_many :bookings
  has_many :users, through: :bookings
end
