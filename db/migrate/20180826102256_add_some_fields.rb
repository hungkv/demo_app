class AddSomeFields < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :access_id, :string
    add_column :users, :access_pass, :string
    add_column :users, :gmo_order_id, :string
    add_column :users, :is_draft, :bolean
    add_column :users, :unionpay_token, :string
    add_column :users, :unionpay_start_url, :string
    add_column :users, :amount, :decimal, default: 0
    add_column :users, :paid, :boolean, default: false
    add_column :users, :payment_at, :datetime
    add_column :users, :plan_name, :string
  end
end
