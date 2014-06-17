require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  fixtures :addresses
  
  test "is not valid without city" do
    address = addresses(:london)
    address.city = nil
    address.valid?
    assert address.errors.has_key?(:city)
  end
  
  test "is not valid without street" do
    address = addresses(:london)
    address.street = nil
    address.valid?
    assert address.errors.has_key?(:street)
  end
  
  test "is not valid without zip code" do
    address = addresses(:london)
    address.zip_code = nil
    address.valid?
    assert address.errors.has_key?(:zip_code)
  end
  
  test "is not valid with wrong zip code format" do
    address = addresses(:london)
    address.zip_code = "666-22"
    address.valid?
    assert address.errors.has_key?(:zip_code)
  end
  
  test "is valid with wrong zip code format" do
    address = addresses(:london)
    address.zip_code = "66-222"
    assert address.valid?
  end
end
