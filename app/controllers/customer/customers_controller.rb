class Customer::CustomersController < ApplicationController
  def show
    @customer = current_customer
  end

  def quit
  end

  def out
  end

  def edit
     @customer = current_customer
  end

  def update
  end
end
