# module Concerns
module MessageScheduler
  module WxUser

    def new_banner(banner)
      puts "PREPARING NEW BANNER MSG"
      note_params = {
        openid: self.oa_open_id,
        unionid: self.union_id, # needed to retrieve oa_open_id if it is not present
        pagepath: "pages/index/index",
        title: banner.title,
        text: banner.promo_text
      }
      WechatNotifier.new_banner(note_params)
      # wx_params[:deliver_at] = begins_at - 4.hours
      # wx_params
    end
  end
end
# end
