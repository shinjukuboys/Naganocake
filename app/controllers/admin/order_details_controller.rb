class Admin::OrderDetailsController < ApplicationController
    before_action :authenticate_admin!

    def update #注文ステータス・製作ステータスの更新
        @order_detail = OrderDetail.find(params[:id])
        @order = @order_detail.order
        @order_details = @order_detail.order.order_details
        @order_detail.update(order_detail_params)
        if @order_detail.in_production? #enum確認メソッド
           @order.in_production! #enum更新メソッド
        elsif @order_details.count == @order_details.production_complete.count #countメソッドを使って比較するステータスの数を数える
           @order.ready_to_ship! #enum更新メソッド
        end
        redirect_to admin_order_path(@order_detail.order)
    end

    private
    def order_detail_params
       params.require(:order_detail).permit(:maiking_status)
    end
end
