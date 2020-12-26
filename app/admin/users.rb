ActiveAdmin.register User do

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
    column :id
    column :email
    column :name
    column :created_at
    column :admin
    column :updated_at
    column :city
    column :wechat
    column :phone
    column :mp_email
    column :gender
    column :wx_open_id
    column :first_name
    column :last_name
    column :workout_name
    column :emergency_name
    column :emergency_phone
    column :birthday
    column :nationality
    column :profession
    column :profession_activity_level
    column :favorite_song
    column :music_styles
    column :sports
    column :favorite_food
    column :voucher_count
    column :instructor
    column :instructor_bio
    column :cn_instructor_bio
    column :height
    column :current_weight
    column :current_body_fat
    column :current_shapes
    column :target
    column :target_weight
    column :target_body_fat
    column :target_shapes
    actions
  end

form title: 'Users' do |f|
    inputs 'Details of Users' do
      input :name, label: "name"
      li "Created at #{f.object.created_at}" unless f.object.new_record?
      li "Updated at #{f.object.updated_at}" unless f.object.new_record?
      input :name, label: "Name"
      input :city, label: "City"
      input :wechat, label: "WeChat"
      input :phone, label: "Phone"
      input :mp_email, label: "Email"
      input :gender, label: "Gender"
      input :wx_open_id, label: "OpenId"
      input :first_name, label: "First Name"
      input :last_name, label: "Last Name"
      input :workout_name, label: "Workout Name"
      input :emergency_name, label: "Emergency Name"
      input :emergency_phone, label: "Emergency Phone"
      input :birthday, label: "Birthday"
      input :nationality, label: "Nationality"
      input :profession, label: "Profession"
      input :profession_activity_level, label: "Profession activity level"
      input :favorite_song, label: "Favorite_song"
      input :music_styles, label: "Music styles"
      input :sports, label: "Sports"
      input :favorite_food, label: "Favorite food"
      input :voucher_count, label: "Vouchers"
      input :instructor, label: "Instructor"
      input :instructor_bio, label: "Instructor bio"
      input :cn_instructor_bio, label: "CN Instructor bio"
      input :height, label: "Height"
      input :current_weight, label: "Current weight"
      input :current_body_fat, label: "Current body fat"
      input :current_shapes, label: "Current shapes"
      input :target, label: "Target"
      input :target_weight, label: "Target weight"
      input :target_body_fat, label: "Target body fat"
      input :target_shapes, label: "Target shapes"
    end
    # panel 'Markup' do
    #   "The following can be used in the content below..."
    # end
    # inputs 'Content', :body
    # para "Press cancel to return to the list without saving."
    actions
  end
  permit_params :name, :city, :phone, :mp_email, :gender, :wx_open_id, :wx_session_key, :first_name, :last_name, :workout_name, :emergency_name, :emergency_phone, :birthday, :nationality , :id, :profession, :profession_activity_level, :favorite_song, :music_styles, :sports, :favorite_food, :voucher_count, :instructor, :instructor_bio, :cn_instructor_bio, :height, :current_weight, :current_body_fat, :current_shapes, :target, :target_weight, :target_body_fat, :target_shapes
# permit_params do

end
