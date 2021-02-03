module Api
  module V1
    class InfosController < Api::BaseController
      def index
        @info = Info.send(params[:scope].to_sym).last
        render_success(@info.standard_hash)
      end
    end
  end
end
