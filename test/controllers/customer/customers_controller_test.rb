require 'test_helper'

class Customer::CustomersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get customer_customers_show_url
    assert_response :success
  end

  test "should get quit" do
    get customer_customers_quit_url
    assert_response :success
  end

  test "should get out" do
    get customer_customers_out_url
    assert_response :success
  end

  test "should get edit" do
    get customer_customers_edit_url
    assert_response :success
  end

  test "should get update" do
    get customer_customers_update_url
    assert_response :success
  end

end
