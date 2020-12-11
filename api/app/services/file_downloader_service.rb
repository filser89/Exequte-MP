class FileDownloaderService
  def self.download(url)
    file = File.open('downloaded_file', "wb") do |f|
      f << HTTParty.get(url)
    end
    file
  end
end

url =
  'https://s5o.ru/storage/simple/ru/edt/90/50/f5/37/rue5f231c5949.jpg'
file = FileDownloaderService.download(url)
