module Api
  module V1
    class TrainingSessionsController < Api::BaseController
      before_action :find_training_session, only: [:show, :add_user_to_queue, :session_attendance, :cancel, :change_capacity]
      before_action :choose_date_range, only: %i[index dates_list]

      def index
        render_success(@date_range.to_a)#.map { |d| DateTimeService.date_wd_d_m(d) })
      end

      def sessions
        date_str = params[:date]
        date_str[-6] = '+'
        date = date_str.to_datetime
        puts "Date: #{date}"
        puts "today: #{DateTime.now.midnight}"
        puts "Date is today? #{date == DateTime.now.midnight}"
        time_range = date == DateTime.now.midnight ? Time.now..date.end_of_day : date.beginning_of_day..date.end_of_day
        sessions = TrainingSession.includes(:bookings, :training, bookings: [:user], training: [:class_type]).where(begins_at: time_range, cancelled: false).order(begins_at: :asc).map { |ts| ts_to_hash(ts) }
        render_success(sessions)
      end

      def cancel
        @training_session.cancelled = true
        @training_session.cancelled_at = DateTime.now
        cancellation_note = params[:note] ? params[:note] : "no reason provided"
        puts "==================training session #{@training_session.name} was canceled with this reason #{cancellation_note}==============="
        @training_session.note = cancellation_note
        puts "===================training session cancelled at #{@training_session.cancelled_at} ========================="
        if @training_session.save
           @training_session.bookings.settled.each do | booking|
             #only refund for bookings that were not cancelled
             if booking.cancelled == false
              puts "#{booking.user.full_name} booked class #{booking.training_session.name}  with #{booking.booked_with}"
              begin
                #return voucher if paid with drop-in or voucher
                if %w[voucher drop-in].include?(booking.booked_with)
                  puts "current user voucher #{booking.user.voucher_count}"
                  booking.user.return_voucher!
                else
                  puts "current user booked with membership, do nothing"
                end
                #cancel the bookings
                puts "==============canceling bookings========="
                booking.cancelled = true
                booking.attended = false
                booking.cancelled_at = DateTime.now
                if booking.save
                  puts "===================booking cancelled at #{booking.cancelled_at} ========================="
                else
                  # render error
                end
              rescue => exceptionThrown
                puts exceptionThrown
                puts  "===================SOMETHING WENT WRONG, ABORT========================="
              end
             end
           end
           puts "=========ABOUT TO SEND WECHAT TEMPLATE MSG FOR CLASS CANCELLATION========"
          #@todo modify below line to be a training session cancellation message
          TrainingSession.notify_cancellation(@training_session)
          render_success({msg: "Cancelled"})
        else
          # render error
        end
      end

      def change_capacity
        @training_session.updated_at = DateTime.now
        new_capacity = params[:capacity]
        puts "==================training session #{@training_session.name}  had this training capacity  #{@training_session.capacity}, changing to #{new_capacity} ==============="
        @training_session.capacity = new_capacity
        if @training_session.save
          puts "=========about to update users in the queue about new capacity========"
          TrainingSession.notify_queue(@training_session)
          render_success({msg: "Capacity changed"})
        else
          render_error({ message: 'Something went wrong' })
        end
      end

      def show
        render_success(ts_to_show_hash(@training_session))
      end

      def add_user_to_queue
        @training_session.queue << current_user.id
        @training_session.save
        render_success(ts_to_show_hash(@training_session))
      end

      def instructor_sessions
        history_ts = current_user
        .training_sessions_as_instructor
        .where('begins_at <= ?', DateTime.now)
        .where(cancelled: false)
        .order(begins_at: :desc)
        .map(&:history_hash)
        upcoming_ts = current_user
        .training_sessions_as_instructor
        .where('begins_at >= ?', DateTime.now)
        .where(cancelled: false)
        .order(:begins_at)
        .map(&:upcoming_hash)
        sessions = [upcoming_ts, history_ts]
        render_success(sessions)
      end

      def admin_sessions
        today = DateTime.now.midnight
        last_day_future = today + 7.days - 1.second
        last_day_past = today - 7.days - 1.second
        date_range_history = (last_day_past..today)
        date_range_future = (today..last_day_future)
        puts "--------#{date_range_history}---------"
        puts "--------#{date_range_future}---------"
        history_ts = TrainingSession.where(
                        begins_at: date_range_history,
                        cancelled: false)
                       .order(begins_at: :desc)
                       .map(&:history_hash)
        upcoming_ts = TrainingSession.where(
                        begins_at: date_range_future,
                        cancelled: false)
                        .order(:begins_at)
                        .map(&:upcoming_hash)
        sessions = [upcoming_ts, history_ts]
        render_success(sessions)
      end

      def dates_list
        @training_sessions = TrainingSession.where(
          training_id: params[:training_id],
          begins_at: @date_range,
          cancelled: false
        ).order(begins_at: :asc)
        render_success(@training_sessions.map { |ts| ts_to_hash(ts).merge!(ts.date_list_hash) })
      end

      def session_attendance
        render_success(@training_session.attendance_hash)
      end

      private

      def choose_date_range
        today = DateTime.now.midnight
        last_day = today + 14.days - 1.second
        @date_range = (today..last_day)
      end

      def ts_to_show_hash(training_session)
        ts_to_hash(training_session).merge!(training_session.show_hash)
      end

      def find_training_session
        @training_session = TrainingSession.find(params[:id])
      end

      def ts_to_hash(training_session)
        h = training_session.standard_hash
        h[:price] = training_session_price(training_session)
        h[:btn_pattern] = btn_pattern(training_session)
        h[:access_options] = access_options(training_session)
        h[:usable_membership] = usable_membership(training_session).booking_hash if usable_membership(training_session)
        h[:usable_classpack] = usable_classpack(training_session).booking_hash if usable_classpack(training_session)
        h
      end

      def training_session_price(training_session)
        kind = training_session.class_kind
        prices = current_user.prices
        training_session.attributes[prices[kind]].fdiv(100)
      end

      def btn_pattern(training_session)
        booked = current_user.bookings.with_ts.any? { |b| b.training_session.id == training_session.id && !b.cancelled && b.settled? }
        if booked
          booking = nil
          current_user.bookings.with_ts.each do | b|
            if b.training_session.id == training_session.id && !b.cancelled && b.settled?
              booking = b
              break
            end
          end
        end
        queued_up = training_session.queue.include?(current_user.id)

        return { disabled: false, action: nil, text: "BOOKED", can_cancel: true, cancel_text: "CANCEL", booking: booking } if booked
        return { disabled: false, action: 'navigateToBooking', text: "COMMIT" } if training_session.can_book? && !booked
        return { disabled: true, action: nil, text: "IN QUEUE" } if queued_up

        { disabled: false, action: 'queueUp', text: "QUEUE UP" }
      end

      def access_options(training_session)
        return { free: true } if training_session.class_kind == 3

        options = { drop_in: true }
        return options if training_session.class_kind == 1

        options[:voucher] = true if current_user.voucher_count.positive?
        options[:membership] = membership_option(training_session)
        options[:classpack] = classpack_option(training_session)
        options
      end

      def usable_membership(training_session)
        current_user.memberships.not_classpack.settled.find_by(
          'start_date <= ? AND end_date > ?',
          training_session.begins_at,
          training_session.begins_at
        )
      end

      def usable_classpack(training_session)
        current_user.memberships.classpack.find_by(
          'start_date <= ? AND end_date > ? AND vouchers > 0',
          training_session.begins_at,
          training_session.begins_at
        )
      end

      def upcoming_membership(training_session)
        current_user.memberships.settled.find_by(
          'start_date >  ?',
          training_session.begins_at
        )
      end

      def membership_option(training_session)
        return 'membership' if usable_membership(training_session)

        'buy-membership' unless upcoming_membership(training_session)
      end

      def classpack_option(training_session)
        return 'classpack' if usable_classpack(training_session)
      end
    end
  end
end
