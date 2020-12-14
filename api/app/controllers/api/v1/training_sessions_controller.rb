module Api
  module V1
    class TrainingSessionsController < Api::BaseController
      before_action :find_training_session, only: [:show, :add_user_to_queue]
      before_action :choose_date_range, only: %i[index dates_list]

      def index
        sessions_array = []
        @date_range.each do |date|
          time_range = date == Date.today ? Time.now..date.end_of_day : date.beginning_of_day..date.end_of_day
          sessions = TrainingSession.includes(:training, training: [:class_type]).where(begins_at: time_range)
          training_sessions = sessions.map { |ts| training_session_to_hash(ts) }
          sessions_array << training_sessions
        end
        render_success({ sessions: sessions_array, dates: @date_range.to_a.map { |d| DateTimeService.date_wd_d_m(d) } })
      end

      def show
        h = training_session_to_hash(@training_session)
        h.merge!(@training_session.show_hash)
        render_success(h)
      end

      def add_user_to_queue
        @training_session.queue << current_user
        @training_session.save
        render_success(@training_session.standard_hash)
      end

      # do I need to have a closure that current_user.instructor
      def instructor_sessions
        history_ts = current_user
        .training_sessions_as_instructor
        .where('begins_at <= ?', DateTime.now)
        .order(begins_at: :desc)
        upcoming_ts = current_user
        .training_sessions_as_instructor
        .where('begins_at >= ?', DateTime.now)
        .order(:begins_at)
        sessions = {
          history: history_ts.map(&:standard_hash),
          upcoming: upcoming_ts.map(&:standard_hash)
        }
        render_success(sessions)
      end

      def dates_list
        @training_sessions = TrainingSession.where(
          training_id: params[:training_id],
          begins_at: @date_range
        ).order(begins_at: :asc)
        render_success(@training_sessions.map { |ts| training_session_to_hash(ts).merge!(ts.date_list_hash) })
      end

      private

      def choose_date_range
        @date_range = (Date.today..13.days.from_now)
      end

      def find_training_session
        @training_session = TrainingSession.find(params[:id])
      end

      def training_session_to_hash(training_session)
        h = training_session.standard_hash
        h[:price] = training_session_price(training_session)
        h
      end

      def training_session_price(training_session)
        kind = training_session.class_kind
        prices = current_user.prices
        training_session.attributes[prices[kind]].fdiv(100)
      end
    end
  end
end
