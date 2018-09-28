class SubcriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def upgrade
    @plan = Plan.find_by_name(params[:plan_name])
  end

  def update
    plan = Plan.find_by_name(params[:plan_name])
    result = BookingUnionpayService.new(current_user, plan).update_account
    if result
      redirect_to subcriptions_unionpay_start_path
    end
  end

  def unionpay_start
    @unionpay_token = current_user.unionpay_token.gsub!(/\s/,'+')
    @access_id = current_user.access_id
    @start_url = current_user.unionpay_start_url
  end

  def unionpay_success
    a = sale_tran_payment
    current_user.update_attributes(payment_at: Time.now, paid: true)
  end

  def sale_tran_payment
    TransactionSaleUnionpayService.new.perform({
      order_id: current_user.gmo_order_id,
      access_id: current_user.access_id,
      access_pass: current_user.access_pass,
      amount: current_user.amount
    })
  end
end
