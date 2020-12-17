module Api
  module V1
    class MembershipsController < Api::BaseController
      def create

        @membership_type = MembershipType.find(params[:membership_type_id])
        @membership = Membership.new(permitted_params)
        @membership.name = @membership_type.name
        @membership.cn_name = @membership_type.cn_name
        @membership.end_date = end_date
        @membership.membership_type = @membership_type
        @membership.price = @membership_type.price
        @membership.user = current_user

        if @membership.save
          render_success(@membership.standard_hash)
        else
          # render_error
        end
      end

      private

      def end_date
        @membership.start_date.midnight + @membership_type.duration.days - 1.second
      end

      def permitted_params
        pars = params.require(:membership)
        pars.each { |par| puts "param: #{par[1]} class: #{par[1].class}" }
        params.require(:membership).permit(:start_date)
      end
    end
  end
end
