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

  form do |f|
    f.inputs "Identity" do
      f.input :name
      f.input :email
    end
    f.inputs "Admin" do
      f.input :admin
    end
    f.actions
  end

  permit_params :name, :email, :admin

end
