class Customer::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @cart_items = current_customer.cart_items.all
    @customer_cart_items = CartItem.where(customer_id: current_customer.id)
  end

  def update
    @cart_item.update(amount: params[:cart_item][:amount].to_i)
    flash.now[:success] = "#{@cart_item.item.name}の数量を変更しました"
    @price = sub_price(@cart_item).to_s(:delimited)
    @cart_items = current_cart
    @total = total_price(@cart_items).to_s(:delimited)
    # redirect_to customers_cart_items_path
  end

  def create
    @cart_item = current_customer.cart_items.new(params_cart_item)
    @item = @cart_item.item

      # カートの中に同じ商品が重複しないようにして　古い商品と新しい商品の数量を合わせる
    @update_cart_item =  CartItem.find_by(item_id: @cart_item.item.id)
    if @update_cart_item.present?
      @cart_item.amount += @update_cart_item.amount
      @update_cart_item.destroy
    end
    if @cart_item.save
      flash[:notice] = "#{@cart_item.item.name}をカートに追加しました"
      redirect_to cart_items_path
    else
      redirect_to item_path(@item), notice: "商品の個数を指定してください"
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path, notice: "#{@cart_item.item.name}を削除しました"
  end

  def destroy_all
    @cart_items = current_customer.cart_items
    @cart_items.destroy_all
    flash[:alert] = "カートの商品を全て削除しました"
    redirect_to cart_items_path
  end

  private

  def params_cart_item
    params.require(:cart_item).permit(:customer_id, :amount, :item_id)
  end
end
