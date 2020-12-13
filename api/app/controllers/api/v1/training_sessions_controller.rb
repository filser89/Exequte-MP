module Api
  module V1
    class TrainingSessionsController < Api::BaseController
      before_action :find_training_session, only: [:show, :add_user_to_queue]

      def index
        # need to add check that the current_user has no booking on this training session.
        # If has => don't add it to the array

        date_range = (Date.today..14.days.from_now)
        sessions_array = []
        date_range.each do |date|
          time_range = date == Date.today ? Time.now..date.end_of_day : date.beginning_of_day..date.end_of_day
          sessions = TrainingSession.includes(:training, training: [:class_type]).where(begins_at: time_range)
          training_sessions = sessions.map { |ts| training_session_to_hash(ts) }
          sessions_array << training_sessions
        end
        render_success({ sessions: sessions_array, dates: date_range.to_a.map { |d| DateTimeService.date_wd_d_m(d) } })
      end

      def show
        h = training_session_to_hash(@training_session)
        h[:description] = @training_session.localize_description
        render_success(h)
      end

      def add_user_to_queue
        @training_session.queue << current_user
        @training_session.save
        render_success(@training_session.standard_hash)
      end

      # do I need to have a closure that current_user.instructor
      def instructor_sessions
        history_ts = current_user.training_sessions_as_instructor.where('begins_at <= ?', DateTime.now).order(begins_at: :desc)
        upcoming_ts = current_user.training_sessions_as_instructor.where('begins_at >= ?', DateTime.now).order(:begins_at)
        sessions = {
          history: history_ts.map(&:standard_hash),
          upcoming: upcoming_ts.map(&:standard_hash)
        }
        render_success(sessions)
      end

      private

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
