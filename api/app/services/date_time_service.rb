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
end
