class BookingUnionpayService
  include Rails.application.routes.url_helpers

  def initialize(user, plan)
    @user = user
    @plan = plan
  end

  def update_account
    entry_transaction
  end

  private

  def entry_transaction
    if @plan.name.downcase != "free"
      @order_id = DateTime.now.strftime("%Q")
      entry_tran = entry_payment
      return entry_tran if entry_tran.key?("ErrCode")
      @access_id = entry_tran["AccessID"]
      @access_pass = entry_tran["AccessPass"]
      @user.access_id = @access_id
      @user.access_pass = @access_pass
      @user.gmo_order_id = @order_id
      @user.plan_name = @plan.name.downcase

      entry_exec = auth_payment
      # return entry_exec if entry_exec.key?(Settings.gmo.error_code)
      @user.unionpay_token = entry_exec["Token"]
      @user.unionpay_start_url = entry_exec["StartURL"]
      @unionpay = true
      @user.save
      entry_exec
    else
      cancel_unionpay
    end
  end

  def entry_payment
    TransactionEntryUnionpayService.new.perform({
      order_id: @order_id,
      job_cd: "AUTH",
      amount: @plan.price.to_i
    })
  end

  def auth_payment
    TransactionExecuteUnionpayService.new.perform({
      order_id: @order_id,
      access_id: @access_id,
      access_pass: @access_pass,
      ret_url: "http://localhost:3000/subcriptions/unionpay_success",
      #ret_url: subcriptions_unionpay_success_path,
      error_rcv_url: "http://localhost:3000"
    })
  end

  def cancel_unionpay
    Rails.logger.info("amount: #{@user.amount}")
    TransactionCancelUnionpayService.new.perform({
      order_id: @user.gmo_order_id,
      access_id: @user.access_id,
      access_pass: @user.access_pass
    })
    @user.update_attributes(plan_name: @plan.name.downcase, paid: false)
  end
end
