class TransactionCancelUnionpayService < BaseService
  def initialize
    @client = GMO::Payment::ShopAPI.new({shop_id: ENV["gmo_shop_id"],
      shop_pass: ENV["gmo_shop_pass"], host: ENV["gmo_host"]})
    @error_info = nil
    @results = nil
  end

  def execute_request(options)
    @client.cancel_tran_unionpay(
      access_id: options[:access_id],
      access_pass: options[:access_pass],
      order_id: options[:order_id]
    )
  end
end
