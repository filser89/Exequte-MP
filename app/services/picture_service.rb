class PictureService
  def get_group_picture_url(session_id, begins_at, from, to, duration, name, location, coach, pic_url)
    api_url = "https://graph.exequte.cn"
    url = "#{api_url}/generate_group_picture_url"
    request_data = {
      begins_at: begins_at,
      session_id: session_id,
      from: from,
      to: to,
      duration: duration,
      name: name,
      location: location,
      coach: coach,
      pic_url: pic_url
    }

    begin
      response = RestClient.post(url, request_data.to_json, content_type: :json)
      if response.code == 200
        return response
      else
        puts "HTTP request failed with status code #{response.code}"
        return nil
      end
    rescue RestClient::ExceptionWithResponse => e
      puts "Error getting picture: #{e.response}"
      return nil
    rescue StandardError => e
      puts "Error getting picture: #{e.message}"
      return nil
    end
  end

end