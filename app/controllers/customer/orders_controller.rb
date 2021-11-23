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
    @total_payment = @order.postage + @cart_items.items_of_price #請求額の合計を割り出す

    if params[:order][:address] == "0" #お届けの方法が自分の住所の時
      @address_name = current_customer.last_name + current_customer.first_name
      @address_postal_cord = current_customer.postal_cord
      @address_address = current_customer.address
    elsif params[:order][:address] == "1" #お届けの方法が登録している住所の時
      @customer_address = Shipping.find(params[:order][:shipping_id])
      @address_name = @customer_address.name
      @saddress_postal_cord = @customer_address.postal_cord
      @address_address = @customer_address.address
    elsif  params[:order][:address] == "2" #新しいお届け先
      @address_name = @order.shipping_name
      @address_postal_cord = @order.shipping_postal_cord
      @address_address = @order.shipping_address
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
      redirect_to orders_thanks_path
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
    params.require(:order).permit(:customer_id, :postage, :total_payment, :payment_method, :name, :postal_cord, :address, :order_status)
  end
end
