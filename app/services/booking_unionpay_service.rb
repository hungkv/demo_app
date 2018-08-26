class BookingUnionpayService
  include Rails.application.routes.url_helpers

  def initialize(user, plan)
    @user = user
    @plan = plan
    # @valid_status = true
    # @errors = {booking_api: "", gmo_api: "", system_err: ""}
    # @neo_code = neo_code
    # @unionpay = false
    # @logger = Logger.new(YokosoLogger.log_path("booking_api"))
  end

  def update_account
    entry_transaction
  end

  private

  def entry_transaction
    @order_id = DateTime.now.strftime("%Q")
    entry_tran = entry_payment
    return entry_tran if entry_tran.key?("ErrCode")
    @access_id = entry_tran["AccessID"]
    @access_pass = entry_tran["AccessPass"]
    @user.access_id = @access_id
    @user.access_pass = @access_pass
    @user.gmo_order_id = @order_id

    entry_exec = auth_payment
    # return entry_exec if entry_exec.key?(Settings.gmo.error_code)
    @user.unionpay_token = entry_exec["Token"]
    @user.unionpay_start_url = entry_exec["StartURL"]
    @unionpay = true
    @user.save
    entry_exec
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
end
