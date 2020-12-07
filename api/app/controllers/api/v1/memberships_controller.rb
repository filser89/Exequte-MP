module Api
  module V1
    class MembershipsController < Api::BaseController
      def create
        @membership_type = MembershipType.find(params[:membership_type_id])
        @membership = Membership.new(permitted_params)
        @membership.name = @membership_type.name
        @membership.cn_name = @membership_type.cn_name
        @membership.duration = @membership_type.duration
        @membership.membership_type = @membership_type
        @membership.user = current_user

        if @membership.save
          render_success(@membership.standard_hash)
        else
          # render_error
        end
      end

      private

      def permitted_params
        params.require(:membership).permit(:start_date)
      end
    end
  end
end
