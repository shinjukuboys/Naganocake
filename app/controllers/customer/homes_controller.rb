class Customer::HomesController < ApplicationController

  def top
    @items = Item.all.order(created_at: :desc)
    #=> :asc,古い順 :desc,新しい順　
  end

  def about
  end

end
