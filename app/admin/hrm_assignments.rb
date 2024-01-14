ActiveAdmin.register HrmAssignment do
  permit_params :hrm_id, :training_session_id, :assigned, :is_used

  index do
    selectable_column
    id_column
    column :hrm
    column :training_session
    column :assigned
    column :is_used
    column 'User' do |hrm_assignment|
      user = hrm_assignment.user
      if user.present?
        link_to user.full_name, admin_user_path(user)
      else
        'N/A'
      end
    end
    column 'Booking' do |hrm_assignment|
      if hrm_assignment.booking.present?
        link_to hrm_assignment.booking.id, admin_booking_path(hrm_assignment.booking)
      else
        'N/A'
      end
    end
    actions
  end
end
