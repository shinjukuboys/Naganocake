class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @orders = Order.page(params[:page]).per(10)
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details.all
    # 下記３行は商品合計を出すため
    @sum = 0
    @subtotals = @order_details.map { |order_detail| order_detail.price * order_detail.amount }
    @sum = @subtotals.sum
  end

  def update
   #注文ステータスの更新
      @order = Order.find(params[:id])
      @order.update(order_params)
      if @order.payment_confirm? #enumの確認メソッド
        @order.order_details.each do |order_detail|
        order_detail.waiting_item! #enumの更新メソッド
      end
  end
      redirect_to admin_order_path
end


  private

  def order_params
    params.require(:order).permit(:order_status)
  end

end