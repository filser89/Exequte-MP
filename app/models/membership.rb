class Membership < ApplicationRecord
  validates :name, presence: true
  validates :cn_name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  monetize :price_cents
  belongs_to :membership_type
  belongs_to :user
  has_many :bookings
  has_many :training_sessions, through: :bookings



  def booking_hash
    h = standard_hash
    h[:start_date] = DateTimeService.date_d_m_y(start_date)
    h[:end_date] = DateTimeService.date_d_m_y(end_date)
    h
  end

  def standard_hash
    {
      id: id,
      name: localize_name,
      price: price.to_i,
      start_date: DateTimeService.date_m_d_y(start_date),
      end_date: DateTimeService.date_m_d_y(end_date),
      smoothie: smoothie
    }
  end

  def pay_params
    {
      body: 'exeQute gym membership',
      out_trade_no: "exeQute_membership_#{id}",
      total_fee: price_cents,
      spbill_create_ip: Socket.ip_address_list.detect(&:ipv4_private?).ip_address,
      notify_url: "https://exequte.cn/api/v1/memperships/payment_confirmed",
      trade_type: "JSAPI",
      openid: user.wx_open_id
    }
  end

  def init_payment
    r = WxPay::Service.invoke_unifiedorder pay_params
    puts "============================INVOKE RESULT===================================="
    p r
    if r.success?
      params = {
        prepayid: r["prepay_id"],
        noncestr: r["nonce_str"]
      }
      puts "===================PARAMS FORMED========================="

      p params
      return WxPay::Service.generate_js_pay_req params
    else
      puts "===================INVOKE FAILED========================="
      p params
    end

    def self.extract_id(result)
      regex = /(?<=_)\d+/
      result[regex].to_i
    end
  end
end
