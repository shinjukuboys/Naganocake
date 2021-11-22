class CartItem < ApplicationRecord
  belongs_to :item
  belongs_to :customer
  
 def total_price
    items.sum("amount*price")
 end 

end
