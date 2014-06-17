require 'test_helper'

class ParkingsTest < ActionDispatch::IntegrationTest
  def setup
    sign_in_test_user
    visit '/parkings'
    @parking = parkings(:one)
  end

  def teardown
    sign_out_test_user
  end

  test "user opens parkings index" do
    assert has_content? 'Parkings'
  end

  test "user opens parking details" do
    click_link "show_#{@parking.id}"
    assert has_content? 'Parking details'
  end

  test "user adds a new parking" do
    click_link 'create new parking'
    assert has_content? 'Create new parking'
    fill_in 'City', :with => 'Warsaw'
    fill_in 'Street', :with => 'Bema'
    fill_in 'Zip code', :with => '77-234'
    select 'private'
    fill_in 'Places', :with => '23'
    fill_in 'Hour price', :with => '2'
    fill_in 'Day price', :with => '20'  
    click_button 'save'
    assert has_content? 'new parking was created'
    assert has_no_content? 'prohibited'  
    assert has_content? 'Warsaw'
  end 

  test "user edits a parking" do
    click_link "edit_#{@parking.id}"
    assert has_content? 'Edit parking'
    fill_in 'City', :with => 'Nowe Miasto'
    fill_in 'Places', :with => '666'
    fill_in 'Hour price', :with => '7'
    fill_in 'Day price', :with => '88'  
    click_button 'save'
    assert has_content? 'Nowe Miasto'
    assert has_content? '666'
    assert has_content? '7'
    assert has_content? '88'
  end

  test "user removes a parking" do
    click_link "remove_#{@parking.id}"
    assert has_content? 'parking was removed'
  end

  test "user searches for parking" do
    choose 'kind_private'
    fill_in 'city', :with => 'Madrid' 
    fill_in 'hour_price_min', :with => '0.00'
    fill_in 'hour_price_max', :with => '2.00'
    fill_in 'day_price_min', :with => '9.00'
    fill_in 'day_price_max', :with => '11.00'
    click_button 'search'
    assert has_content? 'Madrid'
    assert has_no_content? 'London'
  end 
end
