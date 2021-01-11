module Api
  module V1
    class MembershipsController < Api::BaseController
      def create
        @membership_type = MembershipType.find(params[:membership_type_id])
        @membership = Membership.new(permitted_params)
        @membership.name = @membership_type.name
        @membership.cn_name = @membership_type.cn_name
        @membership.smoothie = @membership_type.smoothie
        @membership.end_date = end_date
        @membership.membership_type = @membership_type
        @membership.payment_status = 'pending'
        # @membership.price = @membership_type.price
        @membership.user = current_user

        if @membership.save
          r = @membership.init_payment
          render_success(r)
          # render_success(@membership.standard_hash) // this will move to notify
        else
          # render_error
        end
      end

      def payment_confirmed
        # @membership = Membership.find(params[:id])
        result = Hash.from_xml(request.body.read)['xml']
        puts "===============RESULT=========================="
        p result
        logger.info result.inspect
        if WxPay::Sign.verify?(result)
          @membership = Membership.find(Membership.extract_id(result['out_trade_no']))
          @membership.update!(payment_status: 'paid', payment: result.to_json)
          render xml: { return_code: 'SUCCESS', return_msg: 'OK' }.to_xml(root: 'xml', dasherize: false)
        else
          render :xml => {return_code: "FAIL", return_msg: "Signature Error"}.to_xml(root: 'xml', dasherize: false)
        end

        private

        def end_date
          @membership.start_date.midnight + @membership_type.duration.days - 1.second
        end

        def permitted_params
          pars = params.require(:membership)
          pars.each { |par| puts "param: #{par[1]} class: #{par[1].class}" }
          params.require(:membership).permit(:start_date, :price_cents, :coupon)
        end
      end
    end
  end
end
