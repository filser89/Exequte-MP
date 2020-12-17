module Api
  module V1
    class BookingsController < Api::BaseController
      before_action :find_training_session, only: %i[create attendance_list]
      before_action :find_booking, only: %i[show cancel]
      def index
      end

      def show
        render_success(@booking.show_hash)
      end

      def create
        return render_error('The class is full, please queue up') unless @training_session.can_book?

        @booking = Booking.new(permitted_params)
        @booking.user = current_user
        @booking.training_session = @training_session
        if @booking.save
          @training_session.queue.delete(current_user)
          @training_session.save
          @booking.user.use_voucher! if @booking.booked_with == "voucher"
          render_success(@booking.standard_hash)

        else
          # render error
        end
      end

      def cancel
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

      def find_booking
        @booking = Booking.find(params[:id])
      end

      def find_training_session
        @training_session = TrainingSession.find(params[:training_session_id])
      end

      def permitted_params
        params.require(:booking).permit(:booked_with, :membership_id)
      end
    end
  end
end
