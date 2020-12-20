class Booking < ApplicationRecord
  monetize :price_cents
  belongs_to :user
  belongs_to :training_session
  belongs_to :membership, optional: true

  def upcoming_hash
    h = show_hash
    h[:session][:date] = DateTimeService.date_wd_d_m(training_session.begins_at)
    h
  end

  def history_hash
    h = show_hash
    h[:session][:date] = DateTimeService.date_d_m_y(training_session.begins_at)
    h
  end
  def show_hash
    h = standard_hash
    h[:session] = training_session.show_hash
    h
  end

  def standard_hash
    {
      id: id,
      name: user.name,
      date: training_session.begins_at,
      training_session_id: training_session.id,
      training: training_session.localize_name,
      booked_with: booked_with
    }
  end


  def cancelled_on_time?
    ((training_session.begins_at - cancelled_at) * 24).to_i > training_session.cancel_before
  end
end
