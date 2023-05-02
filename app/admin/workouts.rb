# ActiveAdmin.register Workout do
#
#   # See permitted parameters documentation:
#   # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#   #
#   # Uncomment all parameters which should be permitted for assignment
#   #
#   permit_params :name, :cn_name, :workout_type, :description, :cn_description, training_ids: []
#
#   form do |f|
#     f.semantic_errors # shows errors on :base
#     f.input :name
#     f.input :workout_type, as: :select, collection: Workout.workout_types.keys
#     f.input :exercises_workouts, as: :select, collection: Exercise.all
#     # f.input :exercises, as: :check_boxes, collection: Exercise.all
#     f.actions         # adds the 'Submit' and 'Cancel' buttons
#   end
#   #
#
#
#
#
#
#
#   # or
#   #
#   # permit_params do
#   #   permitted = [:name, :duration, :cn_name, :price_cents, :price_currency, :smoothie]
#   #   permitted << :other if params[:action] == 'create' && current_user.admin?
#   #   permitted
#   # end
#
# end
# In your Active Admin configuration file (e.g. app/admin/workouts.rb)
ActiveAdmin.register Workout do
  permit_params :photo, :video, :name, :cn_name, :description, :cn_description, :workout_type, :training_session_id, :training_id, training_ids: [], training_session_ids: [],  exercises_workouts_attributes: [:id, :exercise_id, :reps, :sets, :weight, :time_limit, :_destroy]

  index do
    selectable_column
    column :id
    column :name
    column :description
    column :workout_type
    column :trainings
    column :photo_link do |workout|
      if workout.photo.attached?
        url = workout.photo.service_url[0..10] +  " ... " + workout.photo.service_url[-20..-1]
        span link_to url, workout.photo.service_url
      end
    end
    column :video_link do |workout|
      if workout.video.attached?
        url = workout.video.service_url[0..10]  + " ... " + workout.video.service_url[-20..-1]
        span link_to url, workout.video.service_url
      end
    end
    column :photo do |workout|
      if workout.photo.attached?
        image_tag workout.photo, width: 50
      end
    end
    column :video do |workout|
      if workout.video.attached?
        video_tag workout.video.service_url, width: 80, controls: true
      end
    end
    column :updated_at
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :cn_name
      row :workout_type
      row :description
      row :cn_description
      row :trainings
      row :photo_link do |workout|
        if workout.photo.attached?
          span link_to workout.photo.service_url, workout.photo.service_url
        end
      end
      row :photo do |workout|
        if workout.photo.attached?
          image_tag workout.photo, width: 200
        end
      end
      row :video_link do |workout|
        if workout.video.attached?
          span link_to workout.video.service_url, workout.video.service_url
        end
      end
      row :video do |workout|
        if workout.video.attached?
          video_tag workout.video.service_url, controls: true
        end
      end
    end

    panel 'Exercises' do
      table_for workout.exercises_workouts do
        column :exercise
        column :reps
        column :sets
        column :weight
        column :time_limit
        column :created_at
        column :updated_at
      end
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors

    f.inputs 'Workout Details' do
      f.input :name
      f.input :cn_name
      f.input :description
      f.input :cn_description
      f.input :workout_type, as: :select, collection: ['power', 'plyo', 'deload', 'hiit']
      #f.input :workout_type, as: :select, collection: Workout.workout_types.keys
      f.input :trainings, as: :select, collection: Training.all.map { |t| [t.name, t.id] }
      f.input :photo, as: :file
      f.input :video, as: :file
    end

    f.inputs 'Exercises' do
      f.has_many :exercises_workouts, heading: false, allow_destroy: true, new_record: true do |ew|
        ew.input :exercise, as: :select, collection: Exercise.all.map { |e| [e.name, e.id] }
        ew.input :sets
        ew.input :weight
        ew.input :reps
        ew.input :time_limit
      end
    end

    f.actions
  end
end
