ActiveAdmin.register Training do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :calories, :duration, :capacity, :class_type_id, :description, :cn_name, :cn_description, :photo, :subtitle, :cn_subtitle

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs          # builds an input field for every attribute
    f.inputs do
      f.input :photo, as: :file
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end


  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :calories, :duration, :capacity, :class_type_id, :description, :cn_name, :cn_description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end



end
