module Api
  module V1
    class InfosController < Api::BaseController
      def index
        @info = Info.last
        render_success(@info)
      end
    end
  end
end
