# frozen_string_literal: true
class HrmService
  def initialize(api_url)
    @api_url = api_url
  end

  def fetch_heart_rate_data
    # Implement the logic to make an HTTP request to the external backend
    # and retrieve heart rate data.
    # You can use libraries like Net::HTTP, HTTParty, or RestClient for this.
  end
end
