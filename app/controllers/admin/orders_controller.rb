class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @orders = Order.page(params[:page]).per(10)
  end

  def show
    @order = Order.find(params[:id])
    @item_orders = @order.item_orders.all
    # 下記３行は商品合計を出すため
    @sum = 0
    @subtotals = @item_orders.map { |item_order| item_order.once_price * item_order.quantity }
    @sum = @subtotals.sum
  end

  def order_status_update
    @order = Order.find(params[:order][:id])
    if @order.update(params_int(order_params))
      flash[:success] = "注文ステータスを更新しました"
      order_status_is_deposited?(@order)
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "注文ステータスの更新に失敗しました"
      redirect_back(fallback_location: root_path)
    end
  end

  def item_orders_status_update
    @item_order = ItemOrder.find(params[:item_order][:id])
    if @item_order.update(params_int(item_order_params))
      flash[:info] = "製作ステータスを更新しました"
      item_order_status_is_in_production?(@item_order)
      @order = Order.find_by(id: params[:item_order][:order_id])
      item_order_status_is_production_complete?(@order)
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "製作ステータスの更新に失敗しました"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def order_params
    params.require(:order).permit(:order_status)
  end

  def item_order_params
    params.require(:item_order).permit(:item_order_status, :id)
  end

  # 以下２つは、update時formから送られてくる値がデフォルトでstringなのでintegerに変換するためのもの。まずはそもそも整数にできるか調べる（Integer()で変換できれば数値、例外発生したら違う）
  def integer_string?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end

  def params_int(order_params)
    order_params.each do |key, value|
      if integer_string?(value)
        order_params[key] = value.to_i
      end
    end
  end

  # 注文ステータスが「入金確認」になったら紐づく製作ステータス全てを「製作待ち」に自動更新
  def order_status_is_deposited?(order)
    if order.order_status_before_type_cast == 1
      order.item_orders.each do |p|
        p.update(item_order_status: 1)
      end
      flash[:info] = "製作ステータスが「製作待ち」に更新されました"
    end
  end

  # 製作ステータスが全部「製作完了」になったら注文ステータスが「発送準備中」に自動更新
  def item_order_status_is_production_complete?(order)
    if  order.item_orders.all? do |p|
          p.item_order_status_before_type_cast == 3
        end
      order.update(order_status: 3)
      flash[:success] = "注文ステータスが「発送準備中」に更新されました"
    end
  end

  # 製作ステータスが一つでも「製作中」になったら注文ステータスが「製作中」に自動更新
  def item_order_status_is_in_production?(item_order)
    if item_order.item_order_status_before_type_cast == 2
      item_order.order.update(order_status: 2)
      flash[:success] = "注文ステータスが「製作中」に更新されました"
    end
  end
end