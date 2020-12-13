module Api
  module V1
    class BannersController < Api::BaseController
      def index
        @banner = Banner.find_by(current: true)
        render_success(@banner.standard_hash)
      end
    end
  end
end
