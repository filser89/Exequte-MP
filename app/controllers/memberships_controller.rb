class MembershipsController < ApplicationController

  def new
    @membership = Membership.new
  end

  def create
    @membership = Membership.new(permitted_params)
    if permitted_params[:membership_type_id] == ""
      render :new
    else
      @membership_type = @membership.membership_type
      start_date = @membership.start_date.present? ? @membership.start_date.midnight : Date.today.midnight
      end_date = start_date + @membership_type.duration.days - 1.second
      @membership.end_date = end_date
      @membership.name = @membership_type.name
      @membership.cn_name = @membership_type.cn_name
      @membership.price_cents = 0
      @membership.price_currency = @membership_type.price_currency
      @membership.smoothie = @membership_type.smoothie
      @membership.payment_status = "paid"
      @membership.payment = "{}"
      @membership.vouchers = @membership_type.vouchers
      @membership.is_class_pack = @membership_type.is_class_pack
      @membership.bookings_per_day = @membership_type.bookings_per_day
      @membership.is_trial = @membership_type.is_trial
      @membership.is_limited = @membership_type.is_limited
      @membership.credits = @membership_type.credits
      @membership.book_before = @membership_type.book_before
      @membership.is_unlimited = @membership_type.is_unlimited
      @membership.description = @membership_type.description
      @membership.cn_description = @membership_type.cn_description
      @membership.is_voucher = @membership_type.is_voucher

      if @membership.save
        puts "membership saved"
        begin
          user = @membership.user
          puts "======USER NAME:#{user.full_name}========"
          puts "======CURRENT USER CREDITS:#{user.credits.to_i}========"
          user.credits = user.credits.to_i + @membership_type.credits.to_i
          if user.save
            puts "======NEW CREDIT BALANCE :#{user.credits.to_i}========"
          end
        rescue => e
          puts "something went wrong adding user credits"
          puts e
        end
        redirect_to @membership
      else
        render :new
      end
    end
  end

  def show
    @membership = Membership.find(params[:id])
  end

  def permitted_params
    params.require(:membership).permit(
      :membership_type_id,
      :start_date,
      :user_id,
    ).transform_values(&:presence)
  end
end
