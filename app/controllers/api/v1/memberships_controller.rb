module Api
  module V1
    class MembershipsController < Api::BaseController
      skip_before_action :authenticate_api_key!, only: [:payment_confirmed]
      skip_before_action :authenticate_user_from_token!, only: [:payment_confirmed]
      before_action :find_membership, only: [:destroy]


      def create
        puts "===================INSIDE MEMBERSHIPS CREATE========================="
        @membership_type = MembershipType.find(params[:membership_type_id])
        puts "===================FOUND MEMBERSHIP TYPE========================="
        p @membership_type
        @membership = Membership.new(permitted_params)
        puts "=============MEMBERSHIP PARAMS===================="
        p permitted_params
        puts "===================NEW MEMBERSHIP PARAMS OK========================="

        @membership.name = @membership_type.name
        @membership.cn_name = @membership_type.cn_name
        @membership.smoothie = @membership_type.smoothie
        @membership.vouchers = @membership_type.vouchers
        @membership.bookings_per_day = @membership_type.bookings_per_day
        @membership.is_trial = @membership_type.is_trial
        @membership.is_limited = @membership_type.is_limited
        @membership.is_class_pack = @membership_type.is_class_pack
        @membership.credits = @membership_type.credits
        @membership.description = @membership_type.description
        @membership.cn_description = @membership_type.cn_description
        @membership.book_before = @membership_type.book_before
        @membership.settings = @membership_type.settings
        @membership.is_unlimited = @membership_type.is_unlimited
        @membership.end_date = end_date
        @membership.membership_type = @membership_type
        @membership.payment_status = 'pending'
        #do not initiate payment for membership below 1元
        if @membership_type.price_cents < 100
          puts "===================MEMBERSHIP < 1元, no initiate payment========================="
          @membership.payment_status = 'paid'
          begin
          puts "======CURRENT USER CREDITS:#{current_user.credits.to_i}========"
          puts "====user_id:#{current_user.id}"
          current_user.credits = current_user.credits.to_i + @membership_type.credits.to_i
          if current_user.save
            puts "======NEW CREDIT BALANCE :#{current_user.credits.to_i}========"
          end
          rescue => e
            puts "something went wrong saving user credits"
            puts e
          end
        end
        # @membership.price = @membership_type.price
        @membership.user = current_user
        puts "===================VALUES ASSIGNED========================="
        p @membership

        if @membership.save
          puts "===================MEMBERSHIP IS SAVED========================="
          if @membership_type.price_cents > 100
            res = @membership.init_payment
            puts "===================PARAMS ARE GOING TO BE SENT TO MP========================="
            p
          else
            puts "===================MEMBERSHIP < 1元, return ok========================="
            res = "free"
          end
          render_success(membership: @membership, res: res)
          # render_success(@membership.standard_hash) // this will move to notify
        else
          # render_error
        end
      end

      def payment_confirmed
        puts "===================PAYMENT CONFIRMED========================="
        # @membership = Membership.find(params[:id])
        result = Hash.from_xml(request.body.read)['xml']
        puts "===============RESULT=========================="
        p result
        logger.info result.inspect
        if WxPay::Sign.verify?(result)
          @membership = Membership.find(Membership.extract_id(result['out_trade_no']))
          puts "===================MEMBERSHIP FOUNT========================="

          @membership.update(payment_status: 'paid', payment: result.to_json)
          puts "===================MEMBERSHIP UPDATED========================="
          p @membership
          begin
            user = @membership.user
            puts "======CURRENT USER CREDITS:#{user.credits.to_i}========"
            puts "====user_id:#{user.id}"
            user.credits = user.credits.to_i +  @membership.credits.to_i
            if user.save
              puts "======NEW CREDIT BALANCE :#{user.credits.to_i}========"
            end
          rescue => e
            puts "something went wrong saving user credits"
            puts e
          end
          render xml: { return_code: 'SUCCESS', return_msg: 'OK' }.to_xml(root: 'xml', dasherize: false)
        else
          puts "===================SIGNATURE ERROR========================="
          render :xml => {return_code: "FAIL", return_msg: "Signature Error"}.to_xml(root: 'xml', dasherize: false)
        end
      end

      def destroy
        @membership.destroy
        render_success({msg: "Failed membership destroyed"})
      end

      private

      def find_membership
        @membership = Membership.find(params[:id])
      end

      def end_date
        start_date = @membership.start_date.present? ? @membership.start_date.midnight : Date.today.midnight
        start_date + @membership_type.duration.days - 1.second
      end


      def permitted_params
        puts "====================INSIDE PERMITTED PARAMS============================"
        # pars = params.require(:membership)
        # pars.each { |par| puts "param: #{par[1]} class: #{par[1].class}" }
        p params
        params.require(:membership).permit(:start_date, :price_cents, :coupon)
      end
    end
  end
end
