class DateTimeService
  def self.time_24_h_m(datetime) # "08:11"
    datetime.strftime("%H:%M")
  end

  def self.date_wd_d_m(datetime) # "Sun 13 Dec"
    datetime.strftime("%a %e %b")
  end

  def self.date_long_wd_m_d_y(datetime) # "Monday, December 14, 2020"
    datetime.strftime("%A, %B %e, %Y")
  end

  def self.date_d_m_wd(datetime)
    datetime.strftime("%e/%-m %a") # "14/7 Tue"
  end

  def self.date_y_m_d(datetime)
    datetime.strftime("%Y-%m-%d") # "2020-12-27"
  end

  def self.date_d_m_y(datetime)
    datetime.strftime("%d/%m/%Y") # "27/12/2020"
  end

  def self.date_m_d_y(datetime)
    datetime.strftime("%b %d, %Y") # "Dec 25, 2020"
  end

  def self.time_12_h_m(datetime)
    datetime.strftime("%l:%M %p")
  end
end
