# module Concerns
module MessageScheduler
  module WxUser

    def new_banner
      puts "PREPARING NEW BANNER MSG"
      begins_at = self.training_session.begins_at
      note_params = {
        openid: self.wx_open_id,
        pagepath: "index",
        title: Banner.find_by(current: true).title,
        text: Banner.find_by(current: true).promo_text
      }
      wx_params = WechatNotifier.booking_reminder(note_params)
      wx_params[:deliver_at] = begins_at - 4.hours
      wx_params
    end
  end
end
# end
