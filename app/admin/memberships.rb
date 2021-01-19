ActiveAdmin.register Membership do
  # belongs_to :membership_type
  # belongs_to :user
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :membership_type_id, :user_id, :name, :cn_name, :price_cents, :price_currency, :start_date, :end_date, :smoothie
  #
  # or
  #
  # permit_params do
  #   permitted = [:membership_type_id, :user_id, :name, :cn_name, :price_cents, :price_currency, :start_date, :end_date, :smoothie]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  json_editor
end
