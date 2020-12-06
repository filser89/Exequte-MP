# Destroy old stuff

puts "Destroying Data..."
Booking.destroy_all
TrainingSession.destroy_all
Training.destroy_all
ClassType.destroy_all
User.destroy_all
Membership.destroy_all
MembershipType.destroy_all
# Create 3 class types
puts "=============================================="

# Creating Instructor

puts "Creating Instructor"

instructor = User.create!(name: "Mr. Instructor", instructor: true)

puts "Created a coach: #{instructor.name}"

puts "Creating Class Types"

premium = ClassType.create!(name: "Premium", kind: 1, price_1: 250, price_2: 250, price_3: 250, price_4: 250, price_5: 250, price_6: 250, price_7: 250, cancel_before: 240)
puts "Created ClassType #{premium.name}"

standard = ClassType.create!(name: "Standard", kind: 2, price_1: 130, price_2: 110, price_3: 90, price_4: 80, price_5: 70, price_6: 60, price_7: 60, cancel_before: 240)

puts "Created ClassType #{standard.name}"


free = ClassType.create!(name: "Free", kind: 3, price_1: 0, cancel_before: 240)
puts "Created ClassType #{free.name}"

puts "=============================================="
# Create 5 trainings
# Create 25 training_sessions

puts "Creating Trainings and Training Sessions"

yoga = Training.create!(name: "Yoga", cn_name: "CHINESE Yoga", calories: 200, duration: 90, capacity: 6, class_type: premium, description: "Stretch your body and mind with us", cn_description: "CHINESE Stretch your body and mind with us")

puts "Created Training #{yoga.name}"

# Up-coming sessions
5.times do
  session = TrainingSession.new(begins_at: rand(DateTime.now..DateTime.now + 14.days), training: yoga, instructor: instructor)
  t = session.training
  session.update!(duration: t.duration, capacity: t.capacity, calories: t.calories, name: t.name, cn_name: t.cn_name, description: t.description, cn_description: t.cn_description, class_kind: t.class_type.kind, cancel_before: t.class_type.cancel_before)
  session.price_1 = t.class_type.price_1
  session.price_2 = t.class_type.price_2
  session.price_3 = t.class_type.price_3
  session.price_4 = t.class_type.price_4
  session.price_5 = t.class_type.price_5
  session.price_6 = t.class_type.price_6
  session.price_7 = t.class_type.price_7
  session.save!
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

# Past sessions

5.times do
  session = TrainingSession.new(begins_at: rand(DateTime.now - 28.days..DateTime.now), training: yoga, instructor: instructor)
  t = session.training
  session.update!(duration: t.duration, capacity: t.capacity, calories: t.calories, name: t.name, cn_name: t.cn_name, description: t.description, cn_description: t.cn_description, class_kind: t.class_type.kind, cancel_before: t.class_type.cancel_before)
  session.price_1 = t.class_type.price_1
  session.price_2 = t.class_type.price_2
  session.price_3 = t.class_type.price_3
  session.price_4 = t.class_type.price_4
  session.price_5 = t.class_type.price_5
  session.price_6 = t.class_type.price_6
  session.price_7 = t.class_type.price_7
  session.save!
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

body_pump = Training.create!(name: "Body Pump", cn_name: "CHINESE Body Pump", calories: 300, duration: 60, capacity: 30, class_type: standard, description: "Go crazy with Body Pump", cn_description: "CHINESE Go crazy with Body Pump")
puts "Created Training #{body_pump.name}"

# Up-coming sessions
5.times do
  session = TrainingSession.new(begins_at: rand(DateTime.now..DateTime.now + 14.days), training: body_pump, instructor: instructor)
  t = session.training
  session.update!(duration: t.duration, capacity: t.capacity, calories: t.calories, name: t.name, cn_name: t.cn_name, description: t.description, cn_description: t.cn_description, class_kind: t.class_type.kind, cancel_before: t.class_type.cancel_before)
  session.price_1 = t.class_type.price_1
  session.price_2 = t.class_type.price_2
  session.price_3 = t.class_type.price_3
  session.price_4 = t.class_type.price_4
  session.price_5 = t.class_type.price_5
  session.price_6 = t.class_type.price_6
  session.price_7 = t.class_type.price_7
  session.save!
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

# Past sessions

5.times do
  session = TrainingSession.new(begins_at: rand(DateTime.now - 28.days..DateTime.now), training: body_pump, instructor: instructor)
  t = session.training
  session.update!(duration: t.duration, capacity: t.capacity, calories: t.calories, name: t.name, cn_name: t.cn_name, description: t.description, cn_description: t.cn_description, class_kind: t.class_type.kind, cancel_before: t.class_type.cancel_before)
  session.price_1 = t.class_type.price_1
  session.price_2 = t.class_type.price_2
  session.price_3 = t.class_type.price_3
  session.price_4 = t.class_type.price_4
  session.price_5 = t.class_type.price_5
  session.price_6 = t.class_type.price_6
  session.price_7 = t.class_type.price_7
  session.save!
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

stretching = Training.create!(name: "Stretching", cn_name: "CHINESE Stretching", calories: 200, duration: 70, capacity: 20, class_type: standard, description: "Same like yoga but without Zen", cn_description: "CHINESE Same like yoga but without Zen")

puts "Created Training #{stretching.name}"

# Up-comming sessions
5.times do
  session = TrainingSession.new(begins_at: rand(DateTime.now..DateTime.now + 14.days), training: stretching, instructor: instructor)
  t = session.training
  session.update!(duration: t.duration, capacity: t.capacity, calories: t.calories, name: t.name, cn_name: t.cn_name, description: t.description, cn_description: t.cn_description, class_kind: t.class_type.kind, cancel_before: t.class_type.cancel_before)
  session.price_1 = t.class_type.price_1
  session.price_2 = t.class_type.price_2
  session.price_3 = t.class_type.price_3
  session.price_4 = t.class_type.price_4
  session.price_5 = t.class_type.price_5
  session.price_6 = t.class_type.price_6
  session.price_7 = t.class_type.price_7
  session.save!
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

# Past sessions

5.times do
  session = TrainingSession.new(begins_at: rand(DateTime.now - 28.days..DateTime.now), training: stretching, instructor: instructor)
  t = session.training
  session.update!(duration: t.duration, capacity: t.capacity, calories: t.calories, name: t.name, cn_name: t.cn_name, description: t.description, cn_description: t.cn_description, class_kind: t.class_type.kind, cancel_before: t.class_type.cancel_before)
  session.price_1 = t.class_type.price_1
  session.price_2 = t.class_type.price_2
  session.price_3 = t.class_type.price_3
  session.price_4 = t.class_type.price_4
  session.price_5 = t.class_type.price_5
  session.price_6 = t.class_type.price_6
  session.price_7 = t.class_type.price_7
  session.save!
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

abs = Training.create!(name: "Abs workout", cn_name: "CHINESE Abs workout", calories: 400, duration: 80, capacity: 30, class_type: standard, description: "Go get that 6-pack", cn_description: "CHINESE Go get that 6-pack")

puts "Created Training #{abs.name}"
# Up-comming sessions
5.times do
  session = TrainingSession.new(begins_at: rand(DateTime.now..DateTime.now + 14.days), instructor: instructor, training: abs)
  t = session.training
  session.update!(duration: t.duration, capacity: t.capacity, calories: t.calories, name: t.name, cn_name: t.cn_name, description: t.description, cn_description: t.cn_description, class_kind: t.class_type.kind, cancel_before: t.class_type.cancel_before)
  session.price_1 = t.class_type.price_1
  session.price_2 = t.class_type.price_2
  session.price_3 = t.class_type.price_3
  session.price_4 = t.class_type.price_4
  session.price_5 = t.class_type.price_5
  session.price_6 = t.class_type.price_6
  session.price_7 = t.class_type.price_7
  session.save!
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

# Past sessions

5.times do
  session = TrainingSession.new(begins_at: rand(DateTime.now - 28.days..DateTime.now), training: abs, instructor: instructor)
  t = session.training
  session.update!(duration: t.duration, capacity: t.capacity, calories: t.calories, name: t.name, cn_name: t.cn_name, description: t.description, cn_description: t.cn_description, class_kind: t.class_type.kind, cancel_before: t.class_type.cancel_before)
  session.price_1 = t.class_type.price_1
  session.price_2 = t.class_type.price_2
  session.price_3 = t.class_type.price_3
  session.price_4 = t.class_type.price_4
  session.price_5 = t.class_type.price_5
  session.price_6 = t.class_type.price_6
  session.price_7 = t.class_type.price_7
  session.save!
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

lifting = Training.create!(name: "Weight lifting", cn_name: "CHINESE Weight lifting", calories: 700, duration: 90, capacity: 10, class_type: free, cn_description: "CHINESE Free and powerful workout session", description: "Free and powerful workout session")

puts "Created Training #{lifting.name}"
# Up-comming sessions
5.times do
  session = TrainingSession.new(begins_at: rand(DateTime.now..DateTime.now + 14.days), training: lifting, instructor: instructor)
  t = session.training
  session.update!(duration: t.duration, capacity: t.capacity, calories: t.calories, name: t.name, cn_name: t.cn_name, description: t.description, cn_description: t.cn_description, class_kind: t.class_type.kind, cancel_before: t.class_type.cancel_before)
  session.price_1 = t.class_type.price_1
  session.price_2 = t.class_type.price_2
  session.price_3 = t.class_type.price_3
  session.price_4 = t.class_type.price_4
  session.price_5 = t.class_type.price_5
  session.price_6 = t.class_type.price_6
  session.price_7 = t.class_type.price_7
  session.save!
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

# Past sessions

5.times do
  session = TrainingSession.new(begins_at: rand(DateTime.now - 28.days..DateTime.now), training: lifting, instructor: instructor)
  t = session.training
  session.update!(duration: t.duration, capacity: t.capacity, calories: t.calories, name: t.name, cn_name: t.cn_name, description: t.description, cn_description: t.cn_description, class_kind: t.class_type.kind, cancel_before: t.class_type.cancel_before)
  session.price_1 = t.class_type.price_1
  session.price_2 = t.class_type.price_2
  session.price_3 = t.class_type.price_3
  session.price_4 = t.class_type.price_4
  session.price_5 = t.class_type.price_5
  session.price_6 = t.class_type.price_6
  session.price_7 = t.class_type.price_7
  session.save!
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end


puts "=============================================="
# Create 4 MembershipTypes
puts "Creating Membership Types"
membership = MembershipType.create!(name: "6 weeks unlimited", cn_name: "CHINESE 6 weeks unlimited", duration: 42)
puts "Created membership: #{membership.name}"
membership = MembershipType.create!(name: "12 weeks unlimited", cn_name: "CHINESE 12 weeks unlimited", duration: 84)
puts "Created membership: #{membership.name}"
membership = MembershipType.create!(name: "6 weeks unlimited and smoothie", cn_name: "CHINESE 6 weeks unlimited and smoothie", duration: 42)
puts "Created membership: #{membership.name}"
membership = MembershipType.create!(name: "12 weeks unlimited and smoothie", cn_name: "CHINESE 12 weeks unlimited and smoothie", duration: 84)
puts "Created membership: #{membership.name}"

puts "=============================================="

# # Create Test Users
puts "Creating Test Users"
5.times do |n|
  user = User.create!(name: "Test User #{n + 1}")

  # Attended bookings
  rand(1..20).times  do
    ts = TrainingSession.where(begins_at: 28.days.ago..Date.yesterday).sample


    Booking.create!(user: user, training_session: ts, cancelled: false, attended: true)
  end
  attended = user.bookings.count

  puts "Created #{attended} attended bookings for #{user.name}"
  # Cancelled bookings
  rand(0..5).times do
    ts = TrainingSession.where(begins_at: 28.days.ago..Date.yesterday).sample

    Booking.create!(user: user, training_session: ts, cancelled: true, cancelled_at: ts.begins_at - rand(2..6).hours, attended: false)
  end

  puts "Created #{user.bookings.count - attended} cancelled bookings for #{user.name}"
end

Membership.create!(membership_type: MembershipType.first, user: User.first)

puts "Created a membership it belongs to User.first "

puts "=============================================="
puts "Seeding is completed"
puts "Created #{ClassType.count} Class Types"
puts "Created #{Training.count} Trainings"
puts "Created #{TrainingSession.count} Training Sessions"
puts "Created #{MembershipType.count} Membership Types"
puts "Created #{Membership.count} Membership"
puts "Created #{User.count} Users"
puts "Created #{Booking.count} Bookings"
