class Customer::ItemsController < ApplicationController
  def index
    @items = Item.all
    @items_all = Item.all

    #if
      #@items_all = Item.where(is_active: true)
      # ジャンルが有効かつ商品も販売中の商品のみ表示させる
      #@items = @item_all#.page(params[:page]).reverse_order
    #else
      #@item_all = Item.joins(:genre).where(genres: { is_active: true, id: params[:genre_id] }).where(is_active: true)
      #@items = @item_all.page(params[:page]).reverse_order
      #@index = Genre.find( params[:genre_id]).name
    #end
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end


  private
    def item_params
		parmas.require(:item).permit(:image ,:name, :introduction, :price, :is_active, :genre_id)
	  end
end