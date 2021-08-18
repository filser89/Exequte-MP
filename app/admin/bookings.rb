ActiveAdmin.register Booking do
  # belongs_to :user
  # belongs_to :training_session

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  includes :user, training_session: [:instructor]
  permit_params :user_id, :training_session_id, :price_cents, :price_currency, :cancelled, :cancelled_at, :attended, :booked_with, :membership_id
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
  end


  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs except: [:user, :booked_with]       # builds an input field for every attribute
    f.input :booked_with, collection: Booking::BOOKING_OPTIONS
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
