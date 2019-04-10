require 'test_helper'

class ChefTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(chefname: "tricia", email: "tricia@example.com")
  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "chefname should be present" do
     @chef.chefname = " "
     assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = " "
    assert_not @chef.valid?
  end

  test "name should be less than 30 chars" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end

  test "email should not be longer than 255 chars" do
    @chef.email = "a" * 256 + "@example.com"
    assert_not @chef.valid?
  end

  test "email should accept correct format" do
    valid_emails = %w[user@example.com USER@cox.net john+smith@gmail.com jane.doe@co.uk.org]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid? "#{valids.inspect} should be valid"
    end
  end

    test "email should reject incorrect format" do
      invalid_emails = %w[user@example USER@cox,net john+smith@gmail. jane.doe@co+org]
      invalid_emails.each do |invalids|
        @chef.email = invalids
        assert_not @chef.valid? "#{invalids.inspect} should not be valid"
      end
    end

    test "email should be unique and case-insenstive" do
      duplicate_chef = @chef.dup
      duplicate_chef.email = @chef.email.upcase
      @chef.save
      assert_not duplicate_chef.valid?
    end

    test "email should be lowercase before hitting the db" do
      mixed_email = "JohN@Example.com"
      @chef.email = mixed_email
      @chef.save
      assert_equal mixed_email.downcase, @chef.reload.email
    end
end
