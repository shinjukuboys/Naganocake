require 'test_helper'

class Customer::CartItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customer_cart_items_index_url
    assert_response :success
  end

  test "should get update" do
    get customer_cart_items_update_url
    assert_response :success
  end

  test "should get create" do
    get customer_cart_items_create_url
    assert_response :success
  end

  test "should get destroy" do
    get customer_cart_items_destroy_url
    assert_response :success
  end

  test "should get destroy_all" do
    get customer_cart_items_destroy_all_url
    assert_response :success
  end

end
