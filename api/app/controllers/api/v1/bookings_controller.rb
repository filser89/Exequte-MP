module Api
  module V1
    class BookingsController < Api::BaseController
      def index

      end

      def create
        training_session = TrainingSession.find(params[:training_session_id])
        @booking = Booking.new(permitted_params)
        @booking.user = current_user
        @booking.training_session = training_session
        if @booking.save
          p @booking.user.voucher_count
          p @booking.booked_with

          @booking.user.use_voucher! if @booking.booked_with == "voucher"

          p @booking.user.voucher_count
          render_success(@booking.standard_hash)
        else
          #  render error
        end
      end

      def cancel

      end

      private
      def permitted_params
        params.require(:booking).permit(:booked_with)
      end

    end
  end
end
