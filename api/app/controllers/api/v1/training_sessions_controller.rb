module Api
  module V1
    class TrainingSessionsController < Api::BaseController
      def index
        # need to add check that the current_user has no booking on this training session.
        # If has => don't add it to the array

        date_range = (Date.today..13.days.from_now)
        sessions_array = []
        date_range.each do |date|
          time_range = date == Date.today ? Time.now..date.end_of_day : date.beginning_of_day..date.end_of_day
          sessions = TrainingSession.includes(:training, training: [:class_type]).where(begins_at: time_range)
          training_sessions = sessions.map { |ts| training_session_to_hash(ts) }
          sessions_array << { date => training_sessions }
        end
        render_success(sessions_array)
      end

      def show
        @training_session = TrainingSession.find(params[:id])
        h = training_session_to_hash(@training_session)
        h[:description] = @training_session.localize_description
        render_success(h)
      end

      private

      def training_session_to_hash(training_session)
        h = training_session.standard_hash
        h[:price] = training_session_price(training_session)
        h
      end

      def training_session_price(training_session)
        class_type = training_session.training.class_type
        kind = class_type.kind
        prices = current_user.prices
        class_type.attributes[prices[kind]].fdiv(100)
      end
    end
  end
end
