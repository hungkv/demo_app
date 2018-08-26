class TransactionEntryUnionpayService < BaseService
  TD_FLAG = 0

  def initialize
    @client = GMO::Payment::ShopAPI.new({shop_id: ENV["gmo_shop_id"],
      shop_pass: ENV["gmo_shop_pass"], host: ENV["gmo_host"]})
    @error_info = nil
    @results = nil
  end

  def execute_request(options)
    @client.entry_tran_unionpay(
      amount: options[:amount],
      td_flag: TD_FLAG,
      job_cd: options[:job_cd],
      order_id: options[:order_id]
    )
  end
end
