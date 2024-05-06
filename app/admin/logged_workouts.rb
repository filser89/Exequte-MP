ActiveAdmin.register LoggedWorkout do
  # Permit params as needed
  permit_params :id, :comments, :user_id, :workout_id, :booking_id, :validated, :validated_at, :validated_by, :validation_status, :validation_request_at, logged_exercises_attributes: [:id, :exercise_id, :format, :block, :reps, :reps_gold, :reps_silver, :reps_bronze, :sets, :time_limit, :_destroy, :batch_index, :order, :comments ]

  show do
    attributes_table do
      row :id
      row :workout
      row :booking
      row :user
      row :validated
      row :validated_at
      row :validated_by
      row :validation_status
      row :validation_request_at

      # Add other attributes of the logged workout if needed

      # Display associated logged exercises
      panel "Logged Workout Exercises" do
        # para "Logged Workout ID: #{logged_workout.id}"
        # para "Logged Workout Details: #{logged_workout.inspect}"


        grouped_logged_exercises = logged_workout.logged_exercises.order(:block, :order).group_by(&:block)

        ordered_blocks = ['warm-up', 'block-a', 'block-b', 'block-c', 'finisher', 'cooldown', 'breathing']
        ordered_blocks.each do |block_name|
          exercise_workouts = grouped_logged_exercises[block_name]

          # para "Logged exercise workout Details: #{exercise_workouts.inspect}"

          next if exercise_workouts.blank?

          span block_name.capitalize, class: 'group-heading' do
            table_for exercise_workouts do
              column :order
              column :exercise
              column :block
              column :comments
              column :format
              column :reps
              column :reps_gold
              column :reps_silver
              column :reps_bronze
              column :sets
              column :time_limit
              column :created_at
              column :updated_at
            end
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs 'Logged Workout Details' do
      f.input :workout, collection: Workout.all.order_by_name
      f.input :booking, collection: Booking.all.order_by_create_at, label_method: :title_summary
      f.input :user, collection: User.all.order_by_name
      f.input :comments
      f.input :validated
      f.input :validated_at
      f.input :validated_by
      f.input :validation_status, collection: LoggedWorkout::VALIDATION_OPTIONS
      f.input :validation_request_at

      # Add other inputs for logged workout attributes if needed
    end

    f.inputs 'Exercises' do
      para "Logged Workout Details: #{logged_workout&.logged_exercises&.inspect}"
      f.has_many :logged_exercises, heading: false, allow_destroy: true, new_record: true do |ew|
        exercises_collection = Exercise.all.order_by_name.map { |e| [e.name, e.id] }
        ew.input :exercise, as: :select, collection: exercises_collection
        # ew.input :exercise, as: :select, collection: Exercise.all.order_by_name.map { |e| [e.name, e.id] }
        ew.input :block, as: :select, collection: ['warm-up', 'block-a', 'block-b', 'block-c', 'finisher' , 'cooldown', 'breathing']
        ew.input :format, as: :string, input_html: { id: "format-input-#{ew.object&.id}" }
        ew.input :format, as: :select, collection: ['TABATA', 'EMOM', 'AMRAP', 'OTHER'], prompt: 'Select Format', input_html: { id: "format-select-#{ew.object&.id}" }
        ew.input :reps
        ew.input :reps_gold
        ew.input :reps_silver
        ew.input :reps_bronze
        ew.input :sets
        ew.input :comments
        ew.input :time_limit
        ew.input :order, as: :number
      end
    end

    f.actions
  end
end
