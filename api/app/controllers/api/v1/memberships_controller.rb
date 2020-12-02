module Api
  module V1
    class MembershipsController < Api::BaseController
      def create
        @membership = Membership.new
        @membership.user = current_user
        @membership.membership_type = MembershipType.find(params[:membership_type_id])
        if @membership.save
          render_success(@membership.standard_hash)
        else
          # render_error
        end
      end
    end
  end
end
