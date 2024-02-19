module Api
  module V1
    class InfosController < Api::BaseController
      before_action :find_info, only: [:show]
        def index
        @info = Info.send(params[:scope].to_sym).last
        p @info.standard_hash
        render_success(@info.standard_hash)
      end

      def show
        render_success(@info.standard_hash)
      end

      def find_info
        @info = Info.find(params[:id])
      end
    end
  end
end
