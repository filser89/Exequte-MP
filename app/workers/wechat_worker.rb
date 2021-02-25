class WechatWorker
  include Sidekiq::Worker

  def perform(action, obj_hash, wx_params={})
    # for backwards compatibility
    if wx_params.blank?
      wx_params = obj_hash
      obj_hash = action
    end


    # 5.times{puts ""}
    puts "WECHAT NOTIFICATION WORKER START!!!"

    p obj_hash
    p wx_params

    # return true if Rails.env == "development"
    return true if ENV["staging"] == "true"
    # update object w/ most recent database updates
    unless obj_hash.class == String
      obj_class = obj_hash["model"].constantize
      obj = obj_class.find_by(id: obj_hash["id"])

      return true if obj.blank?
    end
    # check for condition
    if wx_params["condition"].present? && obj_hash.class != String
      p "WORKER RUNNING CONDITION: #{wx_params["condition"]}"
      condition = obj.send(wx_params["condition"].to_sym)
    else
      p "DEFAULT TRUE for NO CONDITION"
      condition = true
    end

    if condition
      puts "NOTIFICATION SENDING!"
      WechatNotifier.notify!(wx_params)
    end
  end
end
