class Membership < ApplicationRecord
  belongs_to :membership_type
  belongs_to :user
end
