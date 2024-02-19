ActiveAdmin.register UserCoupon do
  permit_params :user_id, :coupon_id

  index do
    selectable_column
    id_column
    column :user
    column :coupon
    column :created_at
    actions
  end

  filter :user
  filter :coupon

  form do |f|
    f.inputs "User Coupon Details" do
      f.input :user
      f.input :coupon
    end
    f.actions
  end
end
