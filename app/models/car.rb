class Car < ActiveRecord::Base
  has_many :place_rents
  belongs_to :owner, class_name: "Person"
  accepts_nested_attributes_for :owner
  validates :registration_number, :model, :owner_id, presence: true
  
  def car_registration_number
    "#{registration_number}"
  end
end
