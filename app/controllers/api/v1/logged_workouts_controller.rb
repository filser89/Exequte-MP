module Api
  module V1
    class LoggedWorkoutsController < Api::BaseController
      before_action :find_workout, only: [:show, :cancel, :destroy, :log_workout, :approve_workout, :deny_workout]

      def log_workout
        begin
          if @logged_workout
            logged_exercises_params = params[:logged_exercises]
            if logged_exercises_params.present?
              logged_exercises_params.each do |logged_exercise_params|
                logged_exercise = LoggedExercise.find(logged_exercise_params[:id])
                logged_exercise.update(logged_exercise_params.permit(:reps, :sets, :time_limit, :comments, :weight))
              end
              @logged_workout.validation_status = 'pending'
              @logged_workout.validation_request_at = DateTime.now
              if @logged_workout.save
                puts "workout saved succesfully"
                render_success({ msg: 'Workout logged' })
              else
                render_success({ msg: 'error submitting workout' })
              end
            else
              render_error({ msg: 'No parameters found' })
            end
          else
            render_error({ msg: 'No logged workout found' })
          end
        rescue => e
          puts e
          render_error({ msg: 'An error occurred' })
        end
      end

      def approve_workout
        begin
          if @logged_workout
            validated_by = "eXequte"
            validated_by = params[:validated_by] if params[:validated_by].present?
            @logged_workout.validation_status = 'approved'
            @logged_workout.validated = true
            @logged_workout.validated_at = DateTime.now
            @logged_workout.validated_by = validated_by
            if @logged_workout.save
              render_success({ msg: 'Workout approved', status: "ok"  })
            else
              render_success({ msg: 'error aproving workout', status: "error"  })
            end
          else
            render_error({ msg: 'No logged workout found', status: "error" })
          end
        rescue => e
          puts e
          render_error({ msg: 'An error occurred', status: "error"  })
        end
      end

      def deny_workout
        begin
          if @logged_workout
            validated_by = "eXequte"
            validated_by = params[:validated_by] if params[:validated_by].present?
            @logged_workout.validation_status = 'denied'
            @logged_workout.validated = true
            @logged_workout.validated_at = DateTime.now
            @logged_workout.validated_by = validated_by
            if @logged_workout.save
              puts "workout denied succesfully"
              render_success({ msg: 'Workout denied', status: "ok"  })
            else
              render_success({ msg: 'error denying workout', status: "error"  })
            end
          else
            render_error({ msg: 'No logged workout found', status: "error" })
          end
        rescue => e
          puts e
          render_error({ msg: 'An error occurred', status: "error"  })
        end
      end

      private

      def logged_exercise_params
        params.require(:logged_exercises).map do |logged_exercise|
          logged_exercise.permit(:id, :reps, :sets, :time_limit, :comments, :weight)
        end
      end

      def find_workout
        @logged_workout = LoggedWorkout.find(params[:id])
      end
    end
  end
end
