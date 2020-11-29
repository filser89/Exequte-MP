# Destroy old stuff

puts "Destroying Database"
TrainingSession.destroy_all
Training.destroy_all
ClassType.destroy_all
Membership.destroy_all
MembershipType.destroy_all
# Create 3 class types
puts "=============================================="
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

yoga = Training.create!(name: "Yoga", calories: 200, duration: 90, capacity: 6, class_type: premium, description: "Stretch your body and mind with us")

puts "Created Training #{yoga.name}"
5.times do
  session = TrainingSession.create!(begins_at: rand(DateTime.now..DateTime.now + 14.days), training: yoga)
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

body_pump = Training.create!(name: "Body Pump", calories: 300, duration: 60, capacity: 30, class_type: standard, description: "Go crazy with Body Pump")
puts "Created Training #{body_pump.name}"

5.times do
  session = TrainingSession.create!(begins_at: rand(DateTime.now..DateTime.now + 14.days), training: body_pump)
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

stretching = Training.create!(name: "Stretching", calories: 200, duration: 70, capacity: 20, class_type: standard, description: "Same like yoga but without Zen")

puts "Created Training #{stretching.name}"

5.times do
  session = TrainingSession.create!(begins_at: rand(DateTime.now..DateTime.now + 14.days), training: stretching)
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

abs = Training.create!(name: "Abs workout", calories: 400, duration: 80, capacity: 30, class_type: standard, description: "Go get that 6-pack")

puts "Created Training #{abs.name}"

5.times do
  session = TrainingSession.create!(begins_at: rand(DateTime.now..DateTime.now + 14.days), training: abs)
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end

lifting = Training.create!(name: "Weight lifting", calories: 700, duration: 90, capacity: 10, class_type: free, description: "Free and powerful workout session")

puts "Created Training #{lifting.name}"

5.times do
  session = TrainingSession.create!(begins_at: rand(DateTime.now..DateTime.now + 14.days), training: lifting)
  puts "Created seession for #{session.training.name} at #{session.begins_at}"
end
puts "=============================================="
# Create 4 MembershipTypes
puts "Creating Membership Types"
membership = MembershipType.create!(name: "6 weeks unlimited", duration: 42)
puts "Created membership: #{membership.name}"
membership = MembershipType.create!(name: "12 weeks unlimited", duration: 84)
puts "Created membership: #{membership.name}"
membership = MembershipType.create!(name: "6 weeks unlimited and smoothie", duration: 42)
puts "Created membership: #{membership.name}"
membership = MembershipType.create!(name: "12 weeks unlimited and smoothie", duration: 84)
puts "Created membership: #{membership.name}"

puts "=============================================="
puts "Seeding is completed"
puts "Created #{ClassType.count} Class Types"
puts "Created #{Training.count} Trainings"
puts "Created #{TrainingSession.count} Training Sessions"
puts "Created #{MembershipType.count} Membership Types"
