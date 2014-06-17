require 'test_helper'

class CarsTest < ActionDispatch::IntegrationTest
  def setup
    sign_in_test_user
    visit '/cars'
    @car = cars(:porsche)
  end

  def teardown
    sign_out_test_user
  end
  
  test "user opens cars index" do
    assert has_content? 'Cars index'
  end

  test "user opens car details" do
    click_link "show_#{@car.id}"
    assert has_content? 'Car details'
  end

  test "user adds a new car" do
    click_link 'create new car'
    assert has_content? 'Create new car'
    fill_in 'Model', :with => 'Clio'
    fill_in 'Registration number', :with => 'ZZ 76543'
    click_button 'save'
    assert has_content? 'new car was created'
    assert has_no_content? 'prohibited' 
    assert has_content? 'Clio'
  end 

  test "user edits and updates a car" do
    click_link "edit_#{@car.id}"
    assert has_content? 'Edit car'
    fill_in 'Model', :with => 'model updated'
    click_button 'save'
    assert has_content? 'car was updated'
    assert has_content? 'model updated'
  end

  test "user removes a car" do 
    click_link "remove_#{@car.id}"
    assert has_content? 'car was removed'
    assert has_no_content? 'Cayenne'
  end
end
