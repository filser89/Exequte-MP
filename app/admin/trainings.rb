ActiveAdmin.register Training do

  permit_params :name, :calories, :duration, :capacity, :class_type_id, :description, :cn_name, :cn_description, :photo, :subtitle, :cn_subtitle, :late_booking_minutes, :is_limited, workout_ids: []

  show do
    # training = Training.includes(:workouts).find(params[:id])
    attributes_table do
      row :name
    end

    panel 'Workout Types' do
      table_for training.workouts do
        column :name
        column :workout_type
        column :created_at
        column :updated_at
        column 'Workout Page' do |workout|
          link_to 'View Full Page', admin_workout_path(workout)
        end
        column "Exercises" do |workout|
          ul do
            workout.exercises_workouts.each do |exercise_workout|
              li do
                "#{exercise_workout.exercise.name}: #{exercise_workout.reps} reps, Time: #{exercise_workout.time_limit.present? ? exercise_workout.time_limit  : 'no time limit'}"
              end
            end
          end
        end
      end
    end

    active_admin_comments
  end
end
