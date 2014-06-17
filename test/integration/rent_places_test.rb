require 'test_helper'

class RentPlacesTest < ActionDispatch::IntegrationTest
  def setup
    sign_in_test_user
  end

  def teardown
    sign_out_test_user
  end

  test "user rents a place on a parking" do
    assert has_no_content? 'Sing in'
    visit '/parkings'
    assert has_content? 'Parkings'
    click_link 'Rent a place', :match => :first
    assert has_content? 'Rent a place'
    assert has_content? 'Select end date'
    click_button 'save'
    assert has_content? 'new place rent was created'
  end
end
