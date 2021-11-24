class Customer::OrdersController < ApplicationController
  def new
    @order = Order.new
    @addresses = current_customer.addresses
  end

  def check
    @order = Order.new(order_params) #受け取った注文情報
    @order.customer_id = current_customer.id #注文情報に自分のIDを入れる
    @order.postage = 800 #送料を設定する
    @cart_items = current_customer.cart_items #自分のカート内商品を取り出す
    #@total_payment = @order.postage + @cart_items.sum_of_price #請求額の合計を割り出す

    if params[:order][:addresses] == "0" #お届けの方法が自分の住所の時
      @name = current_customer.last_name + current_customer.first_name
      @postal_code = current_customer.postal_code
      @address = current_customer.address
    elsif params[:order][:addresses] == "1" #お届けの方法が登録している住所の時
      @customer_address = Address.find(params[:order][:address_id])
      @name = @customer_address.name
      @postal_code = @customer_address.postal_code
      @address = @customer_address.address
    elsif  params[:order][:addresses] == "2" #新しいお届け先
      @name = @order.name
      @postal_code = @order.postal_code
      @address = @order.address
    end
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      @cart_items = current_customer.cart_items.all
      @cart_items.each do |cart_item|
        @order_details = @order.order_details.new
        @order_details.item_id = cart_item.item.id
        @order_details.price = cart_item.item.price * 1.1
        @order_details.amount = cart_item.amount
        @order_details.save
        current_customer.cart_items.destroy_all
      end
      redirect_to thanks_orders_path
    else
      @addresses = current_customer.addresses
      render :new
    end
  end

  def thanks
  end

  def index
    @orders = Order.where(customer_id: current_customer.id).page(params[:page]).per(5)
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, :postage, :total_payment, :payment_method, :name, :postal_code, :address, :order_status)
  end
end
