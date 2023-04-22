# Be sure to restart your server when you modify this file.

# ActiveSupport::Reloader.to_prepare do
#   ApplicationController.renderer.defaults.merge!(
#     http_host: 'example.org',
#     https: false
#   )
# end
require 'rufus/scheduler'
scheduler = Rufus::Scheduler.new

scheduler.cron '22 23 * * *' do
  # every day at 23:30 (11:30pm)
  puts "======RUNNING DAILY NO SHOW CANCELLATION POLICY ======="
  time_range = Time.now.beginning_of_day..Time.now.end_of_day
  training_sessions = TrainingSession.where(
    begins_at:  time_range,
    enforce_cancellation_policy: true
  ).order(begins_at: :asc)
  training_sessions.each do | training|
    puts "==========checking the training:#{training.name}, begins_at:#{training.begins_at}========"
    training.bookings.settled.where(cancelled: false, attended: false, booked_with: "membership").each do | booking|
      puts "#{booking.user.full_name} did a no-show on class #{booking.training_session.name} with #{booking.membership_id}"
      begin
        membership = Membership.find(booking.membership_id)
        noshow_automatically_deduct = true
        begin
          noshow_automatically_deduct = Settings.find_by(key: "noshow_automatically_deduct").value
        rescue => e
          puts  "===================SETTING NOT FOUND, USING FALSE as DEFAULT ========================="
          noshow_automatically_deduct = false
        end
        noshow_text = "#{booking.user.full_name} (id:#{booking.user_id}) did a no-show on class #{booking.training_session.name} (time: #{booking.training_session.begins_at} ) with membership #{booking.membership_id}. AUTOMATIC 1 DAY PENALTY APPLIED, Their membership expiration date is now #{membership.end_date}"
        if noshow_automatically_deduct
          membership.change_end_date(-1)
          if membership.save
            puts "===================NO-SHOW DEDUCT MEMBERSHIP IS SAVED========================="
          else
            puts "===================ERROR SAVING MEMBERSHIP========================="
          end
        else
          noshow_text = "#{booking.user.full_name} (id:#{booking.user_id}) did a no-show on class #{booking.training_session.name} (time: #{booking.training_session.begins_at} ) with membership #{booking.membership_id}."
        end
        puts "about to add a log in the log table"
        @logs = Log.new()
        @logs.log_type = "NOSHOW_PENALTY"
        @logs.value = noshow_text
          if @logs.save
          puts "log save successful"
        else
          puts "error saving log"
        end
      rescue => e
        puts  "===================NO-SHOW MEMBERSHIP NOT FOUND, ABORT========================="
      end
    end
  end
end