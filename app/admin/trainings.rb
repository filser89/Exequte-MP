ActiveAdmin.register Training do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :city, :wechat, :phone, :gender, :admin, :wx_open_id, :wx_session_key, :first_name, :last_name, :workout_name, :emergency_name, :emergency_phone, :birthday, :nationality, :profession, :profession_activity_level, :favorite_song, :music_styles, :sports, :favorite_food, :voucher_count, :instructor, :instructor_bio, :cn_instructor_bio, :height, :current_weight, :current_body_fat, :current_shapes, :target, :target_weight, :target_body_fat, :target_shapes
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :city, :wechat, :phone, :gender, :admin, :wx_open_id, :wx_session_key, :first_name, :last_name, :workout_name, :emergency_name, :emergency_phone, :birthday, :nationality, :profession, :profession_activity_level, :favorite_song, :music_styles, :sports, :favorite_food, :voucher_count, :instructor, :instructor_bio, :cn_instructor_bio, :height, :current_weight, :current_body_fat, :current_shapes, :target, :target_weight, :target_body_fat, :target_shapes]
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
    actions
  end


 form title: 'Trainings' do |f|
  inputs 'Details of Trainings' do

    input :name, label: "Name"
    input :cn_name, label: "CN Name"
    input :description, label: "Description"
    input :cn_description, label: "CN Description"
    input :calories, label: "Calories"
    input :duration, label: "Durstion"
    input :capacity, label: "Capacity"
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
