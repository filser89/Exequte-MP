ActiveAdmin.register TrainingSession do
  config.create_another = true
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :queue, :training_id, :begins_at, :user_id, :duration, :capacity, :calories, :name, :cn_name, :price_1_cents, :price_1_currency, :price_2_cents, :price_2_currency, :price_3_cents, :price_3_currency, :price_4_cents, :price_4_currency, :price_5_cents, :price_5_currency, :price_6_cents, :price_6_currency, :price_7_cents, :price_7_currency, :description, :cn_description, :class_kind, :cancel_before
  #
  # or
  #
  # permit_params do
  #   permitted = [:queue, :training_id, :begins_at, :user_id, :duration, :capacity, :calories, :name, :cn_name, :price_1_cents, :price_1_currency, :price_2_cents, :price_2_currency, :price_3_cents, :price_3_currency, :price_4_cents, :price_4_currency, :price_5_cents, :price_5_currency, :price_6_cents, :price_6_currency, :price_7_cents, :price_7_currency, :description, :cn_description, :class_kind, :cancel_before]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    column :name
    column :cn_name
    column :description
    column :cn_description
    column :calories
    column :duration
    column :capacity
    column :cancel_before
    actions
  end


  form title: 'TrainingSessions' do |f|
    inputs 'Details of TrainingSessions' do

      input :name, label: "Name"
      input :cn_name, label: "CN Name"
      input :description, label: "Description"
      input :cn_description, label: "CN Description"
      input :calories, label: "Calories"
      input :duration, label: "Duration (minutes)"
      input :capacity, label: "Capacity (people)"
      # association :class_type
      # input :photo, as: :file
      li "Created at #{f.object.created_at}" unless f.object.new_record?
      li "Updated at #{f.object.updated_at}" unless f.object.new_record?
    end
    actions

    # panel 'Markup' do
    #   "The following can be used in the content below..."
    # end
    # inputs 'Content', :body
    # para "Press cancel to return to the list without saving."
    actions
  end
  permit_params :name, :cn_name, :description, :cn_description, :calories, :duration, :capacity
  # permit_params do

end
