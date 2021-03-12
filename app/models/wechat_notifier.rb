require 'rest-client'

class WechatNotifier < ApplicationRecord
  mattr_accessor :token
  mattr_accessor :token_time
  mattr_accessor :js_ticket
  mattr_accessor :js_ticket_time
  self.abstract_class = true
  COLORS = {header: "#BB2332", body: "#0064FF", footer: "#00E1B4" }

  # =====================================================
  #             TEMPLATES FOR NOTIFICATIONS
  # =====================================================


  def self.templates
    return {
      "booking_reminder" => booking_reminder,
      "notify_queue" => notify_queue,
      "new_banner" => new_banner
    }
  end

  def self.booking_reminder(params={})
    {
      "template_id" => "siNd6GpH_dAD9k8gIHE0sz384YGb96Dx0uG3_Qr8FVQ", #新订单通知
      "receiver" => "oS9Rj68fySLTSNGeAzIkUfUaMVc4",#(params[:openid] || "OPENID"), # receiver's openid
      "pagepath" => (params[:pagepath] || "PAGEPATH"), # Reirect to an MP page on tap
      "header_color" => COLORS[:header], # RED
      "body_color" => COLORS[:body], # BLUE
      "footer_color" => COLORS[:footer], # Spare Leash Green
      "data" => {

        # CUSTOM MESSAGES SENT TO USER
        # Ekaterina can edit!
        "first" => "Your class begins in 4 HOURS!",
        "keyword1" => "#{params[:ts_name]}",
        "keyword2" => "exeQute",
        "keyword3" => "425, Whatever Rd",
        "keyword4" => "#{params[:ts_time]}",
        "remark" => "Please come 15 minutes in advance"
      }
    }
  end

  def self.notify_queue
    {
      "template_id" => "siNd6GpH_dAD9k8gIHE0sz384YGb96Dx0uG3_Qr8FVQ", #新订单通知
      "receiver" => (params[:openid] || "OPENID"), # receiver's openid
      "pagepath" => (params[:pagepath] || "PAGEPATH"), # Reirect to an MP page on tap
      "header_color" => COLORS[:header], # RED
      "body_color" => COLORS[:body], # BLUE
      "footer_color" => COLORS[:footer], # Spare Leash Green
      "data" => {

        # CUSTOM MESSAGES SENT TO USER
        # Ekaterina can edit!
        "first" => "Huuraay!!! Free spot!",
        "keyword1" => "#{params[:ts_name]}",
        "keyword2" => "#{params[:ts_date]}",
        "keyword3" => "#{params[:ts_time]}",
        "remark" => "Hurry up! Tap to book a class!"
      }
    }
  end

  def self.new_banner
    {
      "template_id" => "??????????????????????????????", #新订单通知
      "receiver" => (params[:openid] || "OPENID"), # receiver's openid
      "pagepath" => (params[:pagepath] || "PAGEPATH"), # Reirect to an MP page on tap
      "header_color" => COLORS[:header], # RED
      "body_color" => COLORS[:body], # BLUE
      "footer_color" => COLORS[:footer], # Spare Leash Green
      "data" => {

        # CUSTOM MESSAGES SENT TO USER
        # Ekaterina can edit!
        "first" => "Great news",
        "keyword1" => "#{params[:name]}",
        "keyword2" => "#{params[:title]}",
        "keyword3" => "#{params[:text]}",
        "remark" => "Click to find out more!"
      }
    }
  end




  # ======================================================
  #                 API CONNECTORS
  #              DON'T TOUCH!
  # ======================================================
  def self.token_expired?
    return true if self.token.nil?
    expiration = self.token_time + 100.minutes
    return false if expiration > Time.now
    return true
  end

  def self.get_token
    if self.token_expired?
      self.set_token
    end
    return self.token
  end

  def self.set_token
    app_id = ENV["WX_APP_ID"]
    app_secret = ENV["WX_SECRET"]
    token_url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{app_id}&secret=#{app_secret}"
    result = RestClient.get(token_url)
    r = JSON.parse(result)
    if !r["access_token"].nil?
      self.token = r["access_token"]
      self.token_time = Time.now
    else
      p 'get token failed'
    end
  end

  def self.fetch_token(again=false)
    puts "fetching wx oa token..."
    url = 'https://spareleash.com.cn/wx_token'
    url += "?again=true" if again
    RestClient.get(url).body
  end

  def self.notify!(params={})
    puts 'INSIDE NOFIFY! (NOTIFIER)'
    # if params["second_attempt"]
    #   token = self.fetch_token(true)
    # else
    #   token = self.fetch_token
    # end
    token = "42_0OM_yMSx661IqGsm2yOln2D9S9-RXJAftOxf_M89a3l8LfrCehaNhoPADm-TKoT4yLikiryg5eMrc5Z0hMmB8ZdfkreVaViWSfiwr6bBiHPTcdYdb73GXDIOmu14tXSe-v9vIMp0JafnZgF5INQdAHAPUX"
    post_msg = "https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=#{token}"
    data = {}
    params["data"].each do |k,v|
      color = params["body_color"]
      color = params["header_color"] if k == "first"
      color = params["footer_color"] if k == "remark"
      data[k] = {"value"=> v, "color"=> color}
    end
    miniprogram = {
      "appid" => Rails.application.credentials.wx_mp_app_id
    }
    miniprogram["pagepath"] = params["pagepath"] if params["pagepath"].present?
    msg = {
      "touser"=> params["receiver"],
      "template_id"=> params["template_id"],
      "miniprogram"=> miniprogram,
      "data"=> data
    }
    msg["url"] = params["redirect_url"] if params["redirect_url"].present?

    p '------start send msg--------'
    p msg
    result = RestClient.post(post_msg, msg.to_json)
    p JSON.parse(result)

    errcode  = JSON.parse(result)["errcode"]
    if ["0", 0].include? errcode
      p 'sent out!'
      return true
    elsif params["second_attempt"].blank?
      5.times{p "--------FATAL------ MSG SEND FAILED"}
      p "Trying again..."
      params["second_attempt"] = true
      self.notify!(params)
    else
      5.times{p "--------FATAL------ MSG SEND FAILED"}
      return false
    end
  end

  def subscribe?
    check_sub_url = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{access_token}&openid=#{openid}&lang=zh_CN"
    result = RestClient.get check_sub_url
    subscribe = JSON.parse(result)["subscribe"]
    subscribe == 1 ? false : true
  end

  def self.set_js_ticket
    token = self.get_token
    jsapi_url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{token}&type=jsapi"
    result = RestClient.get(jsapi_url)
    r = JSON.parse(result)
    if !r["ticket"].nil?
      self.js_ticket_time = Time.now
      self.js_ticket = r["ticket"]
    else
      p 'get js_ticket failed'
    end
  end

  def self.get_js_ticket
    return SecureRandom.hex if Rails.env == "development"

    if self.js_ticket_expired?
      self.set_js_ticket
    else
      return self.js_ticket
    end
  end

  def self.js_ticket_expired?
    return true if self.js_ticket.nil?
    expiration = self.js_ticket_time + 110.minutes
    return false if expiration > Time.now
    return true
  end
end
