class Customer::ItemsController < ApplicationController
  def index
    @items = Item.all
    @items_all = Item.all
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end


  private
	def item_params
		parmas.require(:item).permit(:image ,:name, :introduction, :price, :is_active)
	end
end
