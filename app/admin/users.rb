ActiveAdmin.register User do
  # config.create_another = true

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :city, :wechat, :phone, :gender, :admin, :wx_open_id, :wx_session_key, :first_name, :last_name, :workout_name, :emergency_name, :emergency_phone, :birthday, :nationality, :profession, :profession_activity_level, :favorite_song, :music_styles, :sports, :favorite_food, :voucher_count, :instructor, :instructor_bio, :cn_instructor_bio, :height, :current_weight, :current_body_fat, :current_shapes, :target, :target_weight, :target_body_fat, :target_shapes, :mp_email
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :city, :wechat, :phone, :gender, :admin, :wx_open_id, :wx_session_key, :first_name, :last_name, :workout_name, :emergency_name, :emergency_phone, :birthday, :nationality, :profession, :profession_activity_level, :favorite_song, :music_styles, :sports, :favorite_food, :voucher_count, :instructor, :instructor_bio, :cn_instructor_bio, :height, :current_weight, :current_body_fat, :current_shapes, :target, :target_weight, :target_body_fat, :target_shapes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # sidebar "Belongings", only: [:show, :edit] do
  #   ul do
  #     li link_to "Bookings",    admin_user_bookings_path(resource)
  #   end
  # end

  # sidebar "Belongings", only: [:show, :edit] do
  #   ul do
  #     li link_to "Memberships",    admin_user_memberships_path(resource)
  #     li link_to "Bookings",    admin_user_bookings_path(resource)
  #   end
  # end


  index do
    selectable_column
    column :id
    column :first_name
    column :last_name
    column :gender
    column :mp_email
    column :phone
    column :workout_name
    column :emergency_name
    column :emergency_phone
    column :voucher_count
    column :instructor
    column :admin
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    tabs do
      tab "Primary" do
        f.semantic_errors # shows errors on :base
        f.inputs :first_name, :last_name, :workout_name, :wechat, :phone, :mp_email, :emergency_name, :emergency_phone, :voucher_count, :instructor, :admin# builds an input field for every attribute
      end
      tab "Secondary" do
        f.semantic_errors # shows errors on :base
        f.inputs :birthday, :nationality, :profession, :profession_activity_level, :favorite_song, :favorite_food
      end
      tab "Instructor" do
        f.inputs :instructor_bio, :cn_instructor_bio
        f.inputs do
          f.input :instructor_photo, as: :file
        end
      end
      tab "Body" do
        f.semantic_errors # shows errors on :base
        f.inputs :height, :current_weight, :current_body_fat, :current_shapes
        f.inputs do
          f.input :target, collection: User::TARGETS
        end
        f.inputs :target_weight, :target_body_fat
      end
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
  # panel 'Markup' do
  #   "The following can be used in the content below..."
  # end
  # inputs 'Content', :body
  # para "Press cancel to return to the list without saving."
  #   actions
  # end
  # permit_params :name, :city, :phone, :mp_email, :gender, :wx_open_id, :wx_session_key, :first_name, :last_name, :workout_name, :emergency_name, :emergency_phone, :birthday, :nationality , :id, :profession, :profession_activity_level, :favorite_song, :music_styles, :sports, :favorite_food, :voucher_count, :instructor, :instructor_bio, :cn_instructor_bio, :height, :current_weight, :current_body_fat, :current_shapes, :target, :target_weight, :target_body_fat, :target_shapes, :admin, :wechat
  # permit_params do

end
