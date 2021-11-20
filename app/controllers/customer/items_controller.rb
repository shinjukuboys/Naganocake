class Customer::ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @items = Item.all
    @item = Item.find(params[:id])
  end


  private
	def item_params
		parmas.require(:item).permit(:image ,:name, :introduction, :price, :is_active)
	end
end
