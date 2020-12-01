class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :training_session

  def standard_hash
    {
      id: id,
      name: user.name,
      date: training_session.begins_at,
      training: training_session.training.localize_name,
      booked_with: booked_with
    }
  end
end
