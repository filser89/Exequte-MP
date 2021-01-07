module Api
  module V1
    class InfosController < Api::BaseController
      def index
        @info = Info.last
        render_success(@info.standard_hash)
      end
    end
  end
end
