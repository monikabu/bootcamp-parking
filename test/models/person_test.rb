require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  fixtures :people
  
  test "is not valid without first name" do
    person = people(:anakin)
    person.first_name = nil
    person.valid?
    assert person.errors.has_key?(:first_name)
  end
end
