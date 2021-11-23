class OrderDetail < ApplicationRecord
  #0は着手不可、１は製作待ち、２は製作中、３は製作完了
  enum production_status: { not_startable: 0, waiting_production: 1, in_production: 2, production_complete: 3 }
  
  belongs_to :order
  belongs_to :item
end
