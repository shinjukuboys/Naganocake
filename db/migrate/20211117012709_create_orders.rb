class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :customer_id
      t.integer :order_status
      t.integer :postage
      t.integer :total_payment
      t.integer :payment_method
      t.string :name
      t.string :address
      t.string :postal_code

      t.timestamps
    end
  end
end
