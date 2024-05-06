module Api
  module V1
    class LoggedExercisesController < Api::BaseController
      skip_before_action :authenticate_api_key!, only: [:show_all_by_exercise]
      skip_before_action :authenticate_user_from_token!, only: [:show_all_by_exercise]
      before_action :find_logged_exercise, only: %i[show cancel destroy show_all_by_logged_exercise_id]
      def show_all_by_exercise
        exercise = Exercise.find_by(name: params[:exercise_name])

        if exercise
          logged_exercises = LoggedExercise.where(exercise_id: exercise.id)

          if current_user
            logged_exercises = logged_exercises.where(logged_workout_id: current_user.logged_workouts.pluck(:id))
          else
            puts "Request without user, return all exercises unfiltered"
          end

          render json: logged_exercises, status: :ok
        else
          render json: { error: "Exercise not found" }, status: :not_found
        end
      end

      def show_all_by_logged_exercise_id
        if @logged_exercise
          exercise = @logged_exercise.exercise
          if exercise
            logged_exercises = LoggedExercise.where(exercise_id: exercise.id)
            if current_user
              logged_exercises = logged_exercises.where(logged_workout_id: current_user.logged_workouts.pluck(:id))
            else
              puts "Request without user, return all exercises unfiltered"
            end
            render_success(logged_exercises.map(&:standard_hash))
          else
            render json: { error: "Exercise not found" }, status: :not_found
          end
        else
          puts "no exercise found"
          render json: { error: "Exercise not found" }, status: :not_found
        end
      end


      # private
      #
      # def logged_exercise_params
      #   params.require(:logged_exercises).map do |logged_exercise|
      #     logged_exercise.permit(:id, :reps, :sets, :time_limit, :comments, :weight)
      #   end
      # end
      #
      def find_logged_exercise
        @logged_exercise = LoggedExercise.find(params[:id])
      end
    end
  end
end
