class TransactionExecuteUnionpayService < BaseService
  def initialize
    @client = GMO::Payment::ShopAPI.new({shop_id: ENV["gmo_shop_id"],
      shop_pass: ENV["gmo_shop_pass"], host: ENV["gmo_host"]})
    @error_info = nil
    @results = nil
  end

  def execute_request(options)
    @client.exec_tran_unionpay(
      access_id: options[:access_id],
      access_pass: options[:access_pass],
      order_id: options[:order_id],
      ret_url: options[:ret_url],
      error_rcv_url: options[:error_rcv_url]
    )
  end
end
