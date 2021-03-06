ActiveAdmin.register Booking do
  # belongs_to :user
  # belongs_to :training_session

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :training_session_id, :price_cents, :price_currency, :cancelled, :cancelled_at, :attended, :booked_with, :membership_id
  json_editor

  index do
    selectable_column
    column :user_id
    column :training_session_id
    column :class_time
    column :class_name
    column :subtitle
    column :created_at
    column :updated_at
    column :price_cents
    column :price_currency
    column :cancelled
    column :cancelled_at
    column :attended
    column :booked_with
    column :membership_id
    actions
  end


  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs except: [:user, :booked_with]       # builds an input field for every attribute
    f.input :booked_with, collection: Booking::BOOKING_OPTIONS
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :training_session_id, :price_cents, :price_currency, :cancelled, :cancelled_at, :attended, :booked_with, :membership_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
