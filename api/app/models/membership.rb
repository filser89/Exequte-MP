class Membership < ApplicationRecord
  belongs_to :membership_type
  belongs_to :user

  def is_valid?
    days_since_created <= membership_type.duration
  end

  def days_left
    membership_type.duration - days_since_created
  end

  def standard_hash
    {
      id: id,
      name: membership_type.localize_name,
      days_left: days_left
    }
  end
end
