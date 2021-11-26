class AddOrderStatus < ActiveRecord::Migration[5.2]
  def change
      add_column :orders, :order_status, :integer, default: 0, null: false
  end
end
