require "test_helper"

class CsvControllerTest < ActionDispatch::IntegrationTest
  test "should get receipt" do
    get csv_receipt_url
    assert_response :success
  end

  test "should get bill" do
    get csv_bill_url
    assert_response :success
  end

  test "should get order" do
    get csv_order_url
    assert_response :success
  end
end
