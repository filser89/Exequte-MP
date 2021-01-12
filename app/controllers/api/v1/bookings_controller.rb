module Api
  module V1
    class BookingsController < Api::BaseController
      skip_before_action :authenticate_api_key!, only: [:payment_confirmed]
      skip_before_action :authenticate_user_from_token!, only: [:payment_confirmed]
      before_action :find_training_session, only: %i[create attendance_list]
      before_action :find_booking, only: %i[show cancel]
      def index
        render_success([upcoming, cancelled.concat(history)])
      end

      def show
        render_success(@booking.show_hash)
      end

      def create
        return render_error({msg: 'The class is full, please queue up'}) unless @training_session.can_book?

        @booking = Booking.new(permitted_params)
        @booking.user = current_user
        @booking.training_session = @training_session
        @booking.payment_status = @booking.booked_with == 'drop-in' ?  'pending' : 'none'
        if @booking.save
          @training_session.queue.delete(current_user)
          @training_session.save
          @booking.user.use_voucher! if @booking.booked_with == "voucher"
          response = {booking: @booking.standard_hash}
          response[:res] = @booking.init_payment if @booking.booked_with == "drop-in"
          render_success(response)
        else
          return render_error({msg: 'Booking was not created'})
        end
      end

      def payment_confirmed
        puts "===================PAYMENT CONFIRMED========================="
        # @membership = Membership.find(params[:id])
        result = Hash.from_xml(request.body.read)['xml']
        puts "===============RESULT=========================="
        p result
        logger.info result.inspect
        if WxPay::Sign.verify?(result)
          @booking = Booking.find(Booking.extract_id(result['out_trade_no']))
          puts "===================BOOKING FOUND========================="

          @booking.update(payment_status: 'paid', payment: result.to_json)
          puts "===================BOOKING UPDATED========================="
          p @booking
          render xml: { return_code: 'SUCCESS', return_msg: 'OK' }.to_xml(root: 'xml', dasherize: false)
        else
          puts "===================SIGNATURE ERROR========================="
          render :xml => {return_code: "FAIL", return_msg: "Signature Error"}.to_xml(root: 'xml', dasherize: false)
        end
      end

      def cancel
        @booking.cancelled = true
        @booking.attended = false
        @booking.cancelled_at = DateTime.now
        if @booking.save
          if @booking.cancelled_on_time? && %w[voucher drop-in].include?(@booking.booked_with)
            @booking.user.return_voucher!
          end
          render_success({msg: "Cancelled"})
        else
          # render error
        end
      end

      # def attendance_list
      #   bookings = @training_session.bookings.where(cancelled: false)
      #   render_success(bookings)
      # end

      def take_attendance
        attendance_arr = params["_json"]
        attendance_arr.each { |x| Booking.find(x[:id]).update(attended: x[:attended]) }
        render_success({message: "Attendance taken!"})
      end

      private

      def history
        Booking.settled.includes(:training_session, :user)
        .where(user: current_user)
        .references(:training_sessions)
        .where('training_sessions.begins_at <= ?', DateTime.now)
        .order('training_sessions.begins_at DESC')
        .map(&:history_hash)
      end

      def cancelled
        Booking.settled.includes(:training_session, :user)
        .where(user: current_user, cancelled: true)
        .where('training_sessions.begins_at > ?', DateTime.now)
        .order('training_sessions.begins_at DESC')
        .map(&:history_hash)
      end

      def upcoming
        Booking.settled.includes(:training_session, :user)
        .where(user: current_user, cancelled: false)
        .references(:training_sessions)
        .where('training_sessions.begins_at > ?', DateTime.now)
        .order('training_sessions.begins_at ASC')
        .map(&:upcoming_hash)
      end

      def find_booking
        @booking = Booking.find(params[:id])
      end

      def find_training_session
        @training_session = TrainingSession.find(params[:training_session_id])
      end

      def permitted_params
        params.require(:booking).permit(:booked_with, :membership_id, :price_cents, :coupon)
      end
    end
  end
end
