require 'test_helper'

class AccountsTest < ActionDispatch::IntegrationTest
  def setup
    @user = accounts(:one)
  end

  test "user signs up" do
    visit '/accounts/register'
    fill_in 'Email', :with => 'anakin_skywalker@wp.com'
    fill_in 'Password', :with => 'password'
    fill_in 'Password confirmation', :with => 'password'
    click_button 'Sign up'
    assert has_no_content? 'prohibited'
    assert has_content? 'Your account was successfully created'
    click_link 'Sign out'
  end

  test "user signs in" do
    sign_in_test_user
    assert has_content? 'Welcome!'
    click_link 'Sign out'
  end

  test "user signs out" do
    sign_in_test_user
    click_link 'Sign out'
    assert has_content? 'You have successfully logged out'
    #assert has_no_content? 'Signed in as Anakin Skywalker'
  end
end
