ActiveAdmin.register Training do

  permit_params :name, :calories, :duration, :capacity, :class_type_id, :description, :cn_name, :cn_description, :photo, :poster_photo, :subtitle, :cn_subtitle, :late_booking_minutes, :is_limited, :credits, :location, workout_ids: []

  # form do |f|
  #   f.semantic_errors # shows errors on :base
  #   f.inputs          # builds an input field for every attribute
  #   f.inputs do
  #     f.input :photo, as: :file
  #   end
  #   f.inputs 'Location' do
  #     f.input :location, as: :radio, collection: ['reshape', 'glam', 'pt', 'other']
  #   end
  #   f.actions         # adds the 'Submit' and 'Cancel' buttons
  # end
  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :name
      f.input :calories
      f.input :duration
      f.input :capacity
      f.input :class_type
      f.input :description
      f.input :cn_name
      f.input :cn_description
      f.input :photo, as: :file
      f.input :poster_photo, as: :file
      f.input :subtitle
      f.input :cn_subtitle
      f.input :late_booking_minutes
      f.input :is_limited
      f.input :credits
      f.input :location, as: :radio, collection: ['reshape', 'glam', 'pt', 'other'], label: 'Location'
      f.input :workouts, collection: Workout.all
    end

    f.actions # adds the 'Submit' and 'Cancel' buttons
  end

  show do
    # training = Training.includes(:workouts).find(params[:id])
    attributes_table do
      row :name
      row :description
      row :duration
      row :location
      row :credits
      row :capacity
      row :duration
      row :class_type
      row :photo do |t|
        if t.photo.attached?
          image_tag t.photo, width: 200
        end
      end
      row :poster_photo do |t|
        if t.poster_photo.attached?
          image_tag t.poster_photo, width: 200
        end
      end
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
                "#{exercise_workout.exercise&.name}: #{exercise_workout.reps_gold} reps, Time: #{exercise_workout.time_limit.present? ? exercise_workout.time_limit : 'no time limit'}"
              end
            end
          end
        end
      end
    end

    active_admin_comments
  end
end
