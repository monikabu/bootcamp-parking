require 'test_helper'

class ParkingTest < ActiveSupport::TestCase
  fixtures :parkings
  
  def setup
    @parking = parkings(:one)
  end  
  
  test "is not valid without number of places" do
    @parking.places = nil
    @parking.valid?
    assert @parking.errors.has_key?(:places)
  end
  
  test "is not valid without hour price" do
    @parking.hour_price = nil
    @parking.valid?
    assert @parking.errors.has_key?(:hour_price)
  end
  
  test "is not valid without day price" do 
    @parking.day_price = nil
    @parking.valid?
    assert @parking.errors.has_key?(:day_price)
  end
  
  test "is not valid when value not on the list" do
    @parking.kind = "public"
    @parking.valid?
    assert @parking.errors.has_key?(:kind)
  end
  
  test "does not close place rents before destroy" do
    @parking.destroy
    assert_empty(@parking.place_rents.where("end_date > ?", Time.now))
  end
  
  test "does not show private parkings" do
    Parking.private_parkings.each do |parking|
    assert_equal("private", parking.kind)
    end
  end
  
  test "does not show public parkings" do
    Parking.public_parkings.each do |parking|
    assert_not_equal("private", parking.kind)
    end
  end
  
  test "does not show day price from a range" do
    Parking.day_price_in_range(9.00, 11.00).each do |day_price_in_range|
    assert_in_delta 10.00, day_price_in_range.day_price.to_f, 1.00
    end
  end
  
  test "does not show hour price from a range" do
    Parking.hour_price_in_range(0.00, 2.00).each do |hour_price_in_range|
    assert_in_delta 1.00, hour_price_in_range.hour_price.to_f, 1.00
    end
  end
  
  test "does not show parking in a given city" do
    parking_in_city = Parking.parking_city("london")
    parking_in_city.each do |parking|
      assert_equal("london", parking.address.city)
    end
  end
  
  test "search method returns wrong records" do 
    search_parking = Parking.search({ :kind => "private", 
                                       :city => "Madrid", 
                                       :day_price_min => 10.00, 
                                       :day_price_max => 13.00, 
                                       :hour_price_min => 0.00, 
                                       :hour_price_max => 1.00}).first
      assert_equal("Madrid", search_parking.address.city)
      assert_equal("private", search_parking.kind)
      assert_equal(10.00, search_parking.day_price)
      assert_equal(1.00, search_parking.hour_price)
  end
end
