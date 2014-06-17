require 'test_helper'

class PlaceRentTest < ActiveSupport::TestCase
  fixtures :place_rents
  
  def setup
    @place_rent = place_rents(:one)
  end
  
  test "is not valid without start date" do
    @place_rent.start_date = nil
    @place_rent.valid?
    assert @place_rent.errors.has_key?(:start_date)
  end
  
  test "is invalid without end date" do
    @place_rent.end_date = nil
    @place_rent.valid?
    assert @place_rent.errors.has_key?(:end_date)
  end
  
  test "is invalid without parking" do
    @place_rent.parking = nil
    @place_rent.valid?
    assert @place_rent.errors.has_key?(:parking)
  end
  
  test "is invalid without car" do
    @place_rent.car = nil
    @place_rent.valid?
    assert @place_rent.errors.has_key?(:car)
  end
  
  test "wrong price" do
    @place_rent.save
    assert_equal(150, @place_rent.price)
  end
  
  test "does not show current rents" do
    place_rents = PlaceRent.current
    assert_empty(place_rents.where("end_date < ? AND start_date > ?", Time.now, Time.now ))
  end
  
  test "does not show outdated rents" do
    place_rents = PlaceRent.outdated
    assert_empty(place_rents.where("end_date > ?", Time.now))
  end
end
