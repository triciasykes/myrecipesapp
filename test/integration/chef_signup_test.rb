require 'test_helper'

class ChefSignupTest < ActionDispatch::IntegrationTest

  test "should get signup page" do
    get signup_path
    assert_response :success
  end

  test "reject invalid signup" do
    get signup_path
    assert_no_difference "Chefs.count" do
      post chefs_path, params:{ chef: { chefname: " ", email: " ", password: " ", password_confirmation: " "}}
    end
    assert_template 'chefs/new'
    assert_select 'h2.card-title'
    assert_select 'div.card-body'
  end

  test "accept valid signup" do
    get signup_path
    assert_difference "Chefs.count", 1 do
      post chefs_path, params:{ chef: { chefname: " ", email: " ", password: " ", password_confirmation: " "}}
    end
    follow_redirect!
    assert_template 'chef/show'
    assert_not flash.empty?
  end
end
