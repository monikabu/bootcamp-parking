require 'test_helper'

class CarTest < ActiveSupport::TestCase
  fixtures :cars
  
  test "is not valid without registration number" do
    car = cars(:nissan)
    car.registration_number = nil
    car.valid?
    assert car.errors.has_key?(:registration_number)
  end
  
  test "is not valid without model" do
    car = cars(:nissan)
    car.model = nil
    car.valid?
    assert car.errors.has_key?(:model)
  end
  
  test "is not valid without owner" do
    car = cars(:nissan)
    car.owner_id = nil
    car.valid?
    assert car.errors.has_key?(:owner_id)
  end
end
