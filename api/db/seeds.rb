# Destroy old stuff

puts "Destroying Data..."
Booking.destroy_all
TrainingSession.destroy_all
Training.destroy_all
ClassType.destroy_all
Membership.destroy_all
User.destroy_all
MembershipType.destroy_all
puts "=============================================="

# Past and Future ranges
past_range = DateTime.now - 28.days..DateTime.now
future_range = DateTime.now..DateTime.now + 14.days

# Options hashes for models


def t_options(training)
  {
    name: training[:name],
    cn_name: "CHINESE #{training[:name]}",
    calories: (300..700).to_a.map { |x| x / 100 * 100 }.sample,
    duration: (30..90).to_a.map { |x| x / 10 * 10 }.sample,
    capacity: (5..30).to_a.sample,
    class_type: training[:class_type],
    description: training[:description],
    cn_description: "CHINESE #{training[:description]}"
  }
end

# Add Training Session Attributes here
def ts_options(training)
  {
    training: training,
    duration: training.duration,
    capacity: training.capacity,
    calories: training.calories,
    name: training.name,
    cn_name: training.cn_name,
    description: training.description,
    cn_description: training.cn_description,
    class_kind: training.class_type.kind,
    cancel_before: training.class_type.cancel_before,
    price_1: training.class_type.price_1,
    price_2: training.class_type.price_2,
    price_3: training.class_type.price_3,
    price_4: training.class_type.price_4,
    price_5: training.class_type.price_5,
    price_6: training.class_type.price_6,
    price_7: training.class_type.price_7
  }
end

# Test Users
puts "Creating Test Users"
5.times { |n| User.create!(name: "Test User #{n + 1}") }

users = User.where(instructor: false)

puts "Created #{users.count} Users"

# Instructor
puts "Creating Instructor"

instructor = User.create!(name: "Mr. Instructor", instructor: true)

puts "Created a coach: #{instructor.name}"

# Class Types
puts "Creating Class Types"

premium = ClassType.create!(name: "Premium", kind: 1, price_1: 250, cancel_before: 4)
puts "Created ClassType #{premium.name}"

standard = ClassType.create!(
  name: "Standard", kind: 2,
  price_1: 130,
  price_2: 110,
  price_3: 90,
  price_4: 80,
  price_5: 70, price_6: 60,
  price_7: 60,
  cancel_before: 4
)

puts "Created ClassType #{standard.name}"


free = ClassType.create!(name: "Free", kind: 3, price_1: 0, cancel_before: 4)
puts "Created ClassType #{free.name}"

puts "=============================================="

# Traiings and Training Sessions
trainings_arr = [
  { name: "Yoga", description: "Stretch your body and mind with us", class_type: premium },
  { name: "Body Pump", description: "Go crazy with Body Pump", class_type: standard },
  { name: "Stretching", description: "Same like yoga but without Zen", class_type: standard },
  { name: "Abs workout", description: "Go get that 6-pack", class_type: standard },
  { name: "Weight lifting", description: "Free and powerful workout session", class_type: free }
]

puts "Creating Trainings and Training Sessions"

trainings_arr.each do |t|
  training = Training.create!(t_options(t))

  puts "Created Training #{training.name}"

  10.times do |n|
    training_session = TrainingSession.new(ts_options(training))
    range = n < 5 ? past_range : future_range
    training_session.update!(instructor: instructor, begins_at: rand(range))
    puts "Created seession for #{training_session.name} at #{training_session.begins_at}"
  end
end
puts "=============================================="

def attended(var, past_bookings_count, cancelled_bookings_count)
  return unless var < 15

  var.between?(cancelled_bookings_count + 1, past_bookings_count)
end

users.each do |u|
  cancelled_bookings_count = rand(0..5)
  past_bookings_count = rand((cancelled_bookings_count + 5)..15)
  bookings_count = rand((past_bookings_count + 10)..40)
  bookings_count.times do |x|
    n = x + 1
    range = n <= past_bookings_count ? past_range : future_range
    ts = TrainingSession.where(begins_at: range).sample
    Booking.create!(
      user: u,
      training_session: ts,
      cancelled: n <= cancelled_bookings_count,
      cancelled_at: n < cancelled_bookings_count ? ts.begins_at - rand(2..6).hours : nil,
      attended: attended(n, past_bookings_count, cancelled_bookings_count)
    )
  end
  puts "Created #{u.bookings.count} bookings for #{u.name}"
end

puts "=============================================="

# Membership Types
puts "Creating Membership Types"

mt_arr = [
  { name:  "6 weeks unlimited", duration: 42 },
  { name:  "6 weeks unlimited with smoothie", duration: 42 },
  { name:  "12 weeks unlimited", duration: 84 },
  { name:  "12 weeks unlimited with smoothie", duration: 84 }
]

mt_arr.each do |mt|
  membership_type = MembershipType.create!(
    name: mt[:name],
    cn_name: "CHINESE #{mt[:name]}",
    duration: mt[:duration]
  )
  puts "Created membership: #{membership_type.name}"
end

Membership.create!(membership_type: MembershipType.first, user: User.second)

puts "Created a membership it belongs to User.second "

puts "=============================================="
puts "Seeding is completed"
puts "Created #{ClassType.count} Class Types"
puts "Created #{Training.count} Trainings"
puts "Created #{TrainingSession.count} Training Sessions"
puts "Created #{MembershipType.count} Membership Types"
puts "Created #{Membership.count} Membership"
puts "Created #{User.count} Users"
puts "Created #{Booking.count} Bookings"
