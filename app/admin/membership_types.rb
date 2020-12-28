ActiveAdmin.register MembershipType do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :duration, :cn_name, :price_cents, :price_currency, :smoothie
  #

  sidebar "Memberships", only: [:show, :edit] do
    ul do
      li link_to "Memberships",    admin_membership_type_memberships_path(resource)
    end
  end




  # or
  #
  # permit_params do
  #   permitted = [:name, :duration, :cn_name, :price_cents, :price_currency, :smoothie]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
