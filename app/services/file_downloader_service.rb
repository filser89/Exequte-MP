require 'open-uri'

class FileDownloaderService
  def self.download(url)
    #   file = File.open('storage/downloaded_file', "wb") do |f|
    #     f << HTTParty.get(url)
    #   end
    #   file
    URI.open(url)
  end

  def self.filename
    "#{SecureRandom.hex(10)}.jpeg"
  end
end
