ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { 'Quick Actions' }

  content title: proc { "Quick Actions" } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        link_to new_training_session_path do
          'Create schedule (for weeks)'
        end
      end
    end
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        link_to custom_training_sessions_path do
          'Create schedule (at multiple times)'
        end
      end
    end
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        link_to new_membership_path do
          'Add membership'
        end
      end
    end
  end # content
end
