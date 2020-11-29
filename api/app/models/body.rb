class Body < ApplicationRecord
  belongs_to :user
end




#  Models needed:
# 0. Users has many: bookings, memberships, has one bodyAttributes: a lot of profile attrs.
# Methods: has_valid_membership? checks if any of user's memberships can be usered, attendance_rate: calculates av. weekly attendance for the past 4 weeks, returns integer.
# 1. Class_type has many classes, Attributes: 7 prices, cancel_before
# 2. Class belongs to Class_type, has_many training_sessions. Attributes: name, calories, duration, picture, capacity
# 3. Training_session belongs to Class, has many bookings, Attributes: date, time, queue(array of users, empty by default)
# Methods: notify queue (sends notificatios to the users from que array)
# 4. Booking belongs to user, belongs to training_session Attributes: price (saves the booking price of the user),  default false, cancelled boolean, attended: boolean, booked_with(membership, voucher, drop-in), cancelled_at(timestamp)
# Methods: canceled_on_time? checks whether canceled_at + ClassType.cancel_before <= time when the class begins, returns a boolean
# Membership Types has many memberships, Attributes: name, duration
# Membership belongs to membership type, belongs_to user. Attributes: user, membership_type
# Methods: can_use? checks whether Membership.created_at+duration < Date.now




# User sees training sessions including: name(class), price(calculated based on user's attendance and class type), calories(class),  duration(class), picture(class), capacity(class))

# training_sesions controller
# index should return a hash of all the training sessions for the next 14 days. Hash: date => array of training_session with the same date.
# Each training session includes the following info:  name(class), price(calculated based on user's attendance and class type), calories(class),  duration(class), picture(class), capacity(class),participants_count(bookings with cancelled:false)

# users_controller
# returns user hash with the following: user_standard, voucher_count, membership

# IF Capacity > participants_count

# BOOKING process

# User clicks BOOK button
# bookings_controller create method

# Option 1: user has a membership

# New booking is created (user, training session, booked_with: membership)

# Option 2: user wants to use voucher
# New booking is created (user, training session, booked_with: voucher)
# User.voucher_count is decreased by 1

# Option 3: user chooses drop-in (pays via wechat)

# User is redirected to payment, payment is confirmed
# New booking is created (user, training session, booked_with: drop_in, price)

# User is redirected to the booking confirmed page
# bookings_controller show method
# returns a hash with all the neccessary booking details (later displayed on the front-end)


# IF Capacity <= participants_count

# Queue-up process

# User clicks on QUEUE button

# training_session controller, add_to_queue method
# Adds a user to an array of queue


# Cancelation process

# User clicks cancel button
# bookings_controller cancel method:
# 1. Find the booking from params
# 2. change booking.canceled to true, timestamp cancelation
# 3. check if cancelation was on time
# 4. If booking was made with voucher or drop in user.voucher_count +1
# 5. Notify the queue about free spot via official account

# Purchacing memberships

# user clicks PURCHACE BUTTON of listed membership types

# memberships_controller
# 1. check that user has no valid membership
# 2. create a membership(user, membership_type)
