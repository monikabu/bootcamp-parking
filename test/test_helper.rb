ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def sign_in_test_user
    visit '/accounts/login'
    fill_in 'Email', :with => 'anakin_skywalker@wp.pl'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'
  end

  def sign_out_test_user
    click_link 'Sign out'
  end
end

class ActionDispatch::IntegrationTest
	include Capybara::DSL
end
