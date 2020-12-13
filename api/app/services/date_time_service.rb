class DateTimeService
  def self.time_24_h_m(datetime) # "08:11"
    datetime.strftime("%H:%M")
  end

  def self.date_wd_d_m(datetime) # "Sun 13 Dec"
    datetime.strftime("%a %e %b")
  end
end
