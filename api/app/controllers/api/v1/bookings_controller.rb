module Api
  module V1
    class BookingsController < Api::BaseController
      before_action :find_training_session, only: [:create, :attendance_list]
      def index
      end

      def create
        # Add that if the user is in queue for this TS, he should be removed from queue
        @booking = Booking.new(permitted_params)
        @booking.user = current_user
        @booking.training_session = @training_session
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
          render_success(@booking.standard_hash)
        else
          # render error
        end
      end

      def attendance_list
        bookings = @training_session.bookings.where(cancelled: false)
        render_success(bookings)
      end

      def take_attendance
        attendance_arr = params["_json"]
        attendance_arr.each { |x| Booking.find(x[:id]).update(attended: x[:attended]) }
        render_success("Attendance taken!")
      end

      private

      def find_training_session
        @training_session = TrainingSession.find(params[:training_session_id])
      end

      def permitted_params
        params.require(:booking).permit(:booked_with)
      end
    end
  end
end
