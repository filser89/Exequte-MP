ActiveAdmin.register TrainingSession do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :queue, :training_id, :begins_at, :user_id, :duration, :capacity, :calories, :name, :cn_name, :price_1_cents, :price_1_currency, :price_2_cents, :price_2_currency, :price_3_cents, :price_3_currency, :price_4_cents, :price_4_currency, :price_5_cents, :price_5_currency, :price_6_cents, :price_6_currency, :price_7_cents, :price_7_currency, :description, :cn_description, :class_kind, :cancel_before
  #
  # or
  #
  # permit_params do
  #   permitted = [:queue, :training_id, :begins_at, :user_id, :duration, :capacity, :calories, :name, :cn_name, :price_1_cents, :price_1_currency, :price_2_cents, :price_2_currency, :price_3_cents, :price_3_currency, :price_4_cents, :price_4_currency, :price_5_cents, :price_5_currency, :price_6_cents, :price_6_currency, :price_7_cents, :price_7_currency, :description, :cn_description, :class_kind, :cancel_before]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


  form do |f|
    tabs do
      tab "Basic" do
        f.semantic_errors # shows errors on :base
        f.inputs except: %i[price_1_cents price_1_currency price_2_cents price_2_currency price_3_cents price_3_currency price_4_cents price_4_currency price_5_cents price_5_currency price_6_cents price_6_currency price_7_cents price_7_currency queue]# builds an input field for every attribute
      end
      tab "Prices" do
        f.semantic_errors # shows errors on :base
        f.inputs :price_1_cents, :price_1_currency, :price_2_cents, :price_2_currency, :price_3_cents, :price_3_currency, :price_4_cents, :price_4_currency, :price_5_cents, :price_5_currency, :price_6_cents, :price_6_currency, :price_7_cents, :price_7_currency
      end
    end
    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end
