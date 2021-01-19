module Api
  module V1
    class TrainingSessionsController < Api::BaseController
      before_action :find_training_session, only: [:show, :add_user_to_queue, :session_attendance]
      before_action :choose_date_range, only: %i[index dates_list]

      def index
        sessions_array = []
        @date_range.each do |date|
          time_range = date == DateTime.now.midnight ? Time.now..date.end_of_day : date.beginning_of_day..date.end_of_day
          sessions = TrainingSession.includes(:bookings, :training, bookings: [:user], training: [:class_type]).where(begins_at: time_range)
          training_sessions = sessions.map { |ts| ts_to_hash(ts) }
          sessions_array << training_sessions
        end
        render_success({ sessions: sessions_array, dates: @date_range.to_a.map { |d| DateTimeService.date_wd_d_m(d) } })
      end

      def show
        render_success(ts_to_show_hash(@training_session))
      end

      def add_user_to_queue
        @training_session.queue << current_user
        @training_session.save
        render_success(ts_to_show_hash(@training_session))
      end

      # do I need to have a closure that current_user.instructor
      def instructor_sessions
        history_ts = current_user
        .training_sessions_as_instructor
        .where('begins_at <= ?', DateTime.now)
        .order(begins_at: :desc)
        .map(&:history_hash)
        upcoming_ts = current_user
        .training_sessions_as_instructor
        .where('begins_at >= ?', DateTime.now)
        .order(:begins_at)
        .map(&:upcoming_hash)
        sessions = [upcoming_ts, history_ts]
        render_success(sessions)
      end

      def dates_list
        @training_sessions = TrainingSession.where(
          training_id: params[:training_id],
          begins_at: @date_range
        ).order(begins_at: :asc)
        render_success(@training_sessions.map { |ts| ts_to_hash(ts).merge!(ts.date_list_hash) })
      end

      def session_attendance
        render_success(@training_session.attendance_hash)
      end

      private

      def choose_date_range
        puts '=================DATE RANGE====================='
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
        h
      end

      def training_session_price(training_session)
        kind = training_session.class_kind
        prices = current_user.prices
        training_session.attributes[prices[kind]].fdiv(100)
      end

      def btn_pattern(training_session)
        booked = current_user.bookings.any? { |b| b.training_session.id == training_session.id && !b.cancelled }
        queued_up = training_session.queue.include?(current_user)

        return { disabled: true, action: nil, text: "BOOKED" } if booked
        return { disabled: false, action: 'navigateToBooking', text: "BOOK" } if training_session.can_book? && !booked
        return { disabled: true, action: nil, text: "WAITING" } if queued_up

        { disabled: false, action: 'queueUp', text: "QUEUE UP" }
      end

      def access_options(training_session)
        return { free: true } if training_session.class_kind == 3

        options = { drop_in: true }
        return options if training_session.class_kind == 1

        options[:voucher] = true unless current_user.voucher_count.zero?
        options[:membership] = membership_option(training_session)
        options
      end

      def usable_membership(training_session)
        current_user.memberships.where(payment_status: 'paid').find_by(
          'start_date <= ? AND end_date > ?',
          training_session.begins_at,
          training_session.begins_at
        )
      end

      def upcoming_membership(training_session)
        current_user.memberships.find_by(
          'start_date >  ?',
          training_session.begins_at
        )
      end

      def membership_option(training_session)
        return 'membership' if usable_membership(training_session)

        'buy-membership' unless upcoming_membership(training_session)

      end
    end
  end
end
