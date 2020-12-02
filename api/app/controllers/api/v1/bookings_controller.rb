module Api
  module V1
    class BookingsController < Api::BaseController
      def index
      end

      def create

        # Add that if the user is in queue for this TS, he should be removed from queue
        training_session = TrainingSession.find(params[:training_session_id])
        @booking = Booking.new(permitted_params)
        @booking.user = current_user
        @booking.training_session = training_session
        if @booking.save
          @booking.user.use_voucher! if @booking.booked_with == "voucher"
          render_success(@booking.standard_hash)
        else
          # render error
        end
      end

      def cancel
        @booking = Booking.find(params[:id])
        @booking.cancelled = true
        @booking.cancelled_at = DateTime.now
        if @booking.save
          if @booking.cancelled_on_time? && %w[voucher drop-in].include?(@booking.booked_with)
            @booking.user.return_voucher!
          end
          render_success(@booking)
        else
          # render error
        end
      end

      private

      def permitted_params
        params.require(:booking).permit(:booked_with)
      end
    end
  end
end
