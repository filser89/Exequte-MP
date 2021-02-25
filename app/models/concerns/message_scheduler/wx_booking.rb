# module Concerns
module MessageScheduler
  module WxBooking
    def booking_new
      set = ["booking_reminder"]
    end

    def booking_update
      ["booking_paid", "booking_payout", "booking_client_paid", "booking_accepted_client", "booking_cancelled_sitter", "booking_cancelled_customer", "booking_refund"]
    end

    def booking_reminder
      puts "PREPARING NEW REMINDER FOR BOOKING"
      begins_at = self.training_session.begins_at
      note_params = {
        openid: self.user.wx_open_id,
        pagepath: "booking-details?id=#{self.id}",
        ts_name: self.training_session.localize_name,
        ts_time: DateTimeService.time_24_h_m(begins_at)
      }
      wx_params = WechatNotifier.booking_reminder(note_params)
      wx_params[:deliver_at] = begins_at - 4.hours
      wx_params
    end
  end
end
# end
