ActiveAdmin.register Info do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :paragraph_one, :paragraph_two, :paragraph_three, :paragraph_four, :title_one, :title_two, :title_three, :title_four
  #
  # or
  #
  # permit_params do
  #   permitted = [:paragraph_one, :paragraph_two, :paragraph_three, :paragraph_four, :title_one, :title_two, :title_three, :title_four]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
