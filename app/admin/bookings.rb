ActiveAdmin.register Booking do
  # belongs_to :user
  # belongs_to :training_session

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  includes :user, training_session: [:instructor]
  permit_params :user_id, :training_session_id, :price_cents, :price_currency, :cancelled, :cancelled_at, :attended, :booked_with, :membership_id, :hrm_id, :payment_status, :is_fitness_test
  json_editor

  filter :user_id, :as => :select, :collection => User.all.map {|user| [user.last_name, user.id]}, label: 'Client Last Name'
  # filter :training_session_id, :as => :select, :collection => TrainingSession.all.map { |ts| [ts.id]}
  filter :class_time, :as => :date_range, :collection => TrainingSession.all.map { |ts| [ts.begins_at]}
  filter :id, label: 'Booking Id'
  # filter :class_time
  filter :training_session_id
  filter :class_name
  filter :subtitle
  filter :price_cents
  filter :cancelled
  filter :cancelled_at
  filter :attended
  filter :booked_with
  filter :payment_status
  filter :membership_id
  filter :created_at
  filter :updated_at



  index do
    selectable_column
    column :id
    column :client_first_name
    column :client_last_name
    column :user_id
    column :class_time
    column :training_session_id
    column :class_name
    column :subtitle
    column :price_cents
    column :cancelled
    column :cancelled_at
    column :attended
    column :booked_with
    column :payment_status
    column :membership_id
    column :hrm do |booking|
      booking.hrm.display_name if booking.hrm.present?
    end
    column :is_fitness_test
    column :created_at
    column :updated_at
    actions
  end

  csv do
    column :id
    column :user_id
    column :client_first_name
    column :client_last_name
    column :training_session_id
    column :class_name
    column :subtitle
    column :class_time
    column :price_cents
    column :cancelled
    column :cancelled_at
    column :attended
    column :booked_with
    column :payment_status
    column :membership_id
    column :created_at
    column :updated_at
    column :instructor
    column :is_fitness_test
  end

  show do
    tabs do
      tab "Booking Details" do
        attributes_table do
            row :id
            row :client_first_name
            row :client_last_name
            row :user_id
            row :class_time
            row :training_session_id
            row :class_name
            row :subtitle
            row :price_cents
            row :cancelled
            row :cancelled_at
            row :attended
            row :booked_with
            row :payment_status
            row :membership_id
            row :is_fitness_test
            row :hrm do |booking|
              booking.hrm.display_name if booking.hrm.present?
            end
            row :created_at
            row :updated_at
          end
        end
        tab "Logged Workout" do
          panel "Logged Workout Details" do
            if booking.logged_workout.present?
              attributes_table_for booking.logged_workout do
                row :id
                row :validation_status
                row :validated_by
                row :validated_at
                row :validation_request_at
              end
            else
              para "No logged workout associated with this booking."
            end
          end

          panel "Logged Workout Exercises Workouts" do
            if booking.logged_workout.present?
              # Display associated logged exercises
                grouped_logged_exercises = booking.logged_workout.logged_exercises.order(:block, :order).group_by(&:block)
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
                # Add other columns for logged exercise attributes as needed
            else
              para "No logged workout associated with this booking."
            end
          end
        end
      end

    # Display the heart rate data associated with the booking
    if resource.heart_rate_data.present?
      panel 'Heart Rate Data' do
        attributes_table_for resource.heart_rate_data do
          row :id
          row :hrm_data_raw
          row :hrm_data
          row :hrm_graph do |heart_rate_data|
            if heart_rate_data.hrm_graph.present?
              image_tag "data:image/png;base64,#{heart_rate_data.hrm_graph['base64Data']}", height: '100px'
            end
          end
          row :hrm_zone_graph do |heart_rate_data|
            if heart_rate_data.hrm_zone_graph.present?
              image_tag "data:image/png;base64,#{heart_rate_data.hrm_zone_graph['base64Data']}", height: '100px'
            end
          end
          row :created_at
          row :updated_at
        end
      end
    end
    active_admin_comments
  end


  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs except: [:user, :booked_with, :payment_status]       # builds an input field for every attribute
    # Add an input for HRM association
    # f.input :hrm, as: :select, collection: Hrm.all.map { |hrm| [hrm.display_name, hrm.id] }, include_blank: true, label: 'HRM'
    f.input :booked_with, collection: Booking::BOOKING_OPTIONS
    f.input :payment_status, collection: Booking::PAYMENT_OPTIONS
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
  #
  # or

  # sidebar :filters do
  #   render partial: 'search'
  # end

  #
  # permit_params do
  #   permitted = [:user_id, :training_session_id, :price_cents, :price_currency, :cancelled, :cancelled_at, :attended, :booked_with, :membership_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
