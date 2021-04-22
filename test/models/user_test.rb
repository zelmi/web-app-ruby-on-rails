require 'test_helper'
class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User3", password_digest: "1234")
  end
  
  test "should be valid" do 
    assert @user.valid?
  end 
  
  test "name should be present" do 
    @user.name = " " 
    assert_not @user.valid?
  end 

  test "password_digest should be present" do 
    @user.password_digest = " " 
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid? 
  end
  
  test "name should be unique" do
    duplicate_user = @user.dup
    duplicate_user.name = @user.name.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
   
end
end