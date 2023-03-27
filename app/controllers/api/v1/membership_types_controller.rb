module Api
  module V1
    class MembershipTypesController < Api::BaseController
      def index
        #if new user / no bookings were made before, show all class-packs (including trials)
        is_existing_user = current_user.bookings.active.settled.with_ts.any?
        if (is_existing_user)
          puts "======existing user, do not show trial class pack"
          @membership_types = MembershipType.active.not_trial
        else
          puts "======new user,  show trial class pack"
          @membership_types = MembershipType.active
        end
        render_success(@membership_types.map(&:standard_hash))
      end
    end
  end
end
