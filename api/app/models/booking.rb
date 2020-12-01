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

  def cancelled_on_time?
    ((training_session.begins_at - cancelled_at) * 24).to_i > training_session.training.class_type.cancel_before
  end

end
