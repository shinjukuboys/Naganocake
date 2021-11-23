class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details, dependent: :destroy
  
  validates :shipping_name, presence: true
  validates :shipping_address, presence: true
  validates :shipping_post_cord, presence: true
  
  #0は入金待ち（デフォルト）、１は入金確認、２は製作中、３は発送準備中、４は発送済み
  enum status: { waiting_payment: 0, payment_confirm: 1, in_production: 2, ready_to_ship: 3, shipped: 4 }
  enum payment: { クレジットカード: 0, 銀行振込: 1 }
end
