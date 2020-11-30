module Api
  module V1
    class TrainingSessionsController < Api::BaseController
      def index
        @training_sessions = TrainingSession.includes(:training, training: [:class_type]).where(begins_at: Date.today..13.days.from_now)
      end

      def show

      end
    end
  end
end
