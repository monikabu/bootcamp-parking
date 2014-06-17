class Parking < ActiveRecord::Base
  before_destroy :set_end_dates_on_place_rents
  belongs_to :address
  belongs_to :owner, class_name: "Person"
  has_many :place_rents
  accepts_nested_attributes_for :address
  validates :places, :hour_price, :day_price, presence: true
  validates :kind, inclusion: { in: %w(outdoor indoor private street), message:"%{value} is not included in the list"}
  scope :public_parkings, -> { where.not("kind = ?", "private") }
  scope :private_parkings, -> { where("kind = ?", "private") }
  scope :day_price_in_range, -> (min, max) { where("day_price BETWEEN #{min} AND #{max}") }
  scope :hour_price_in_range, -> (min, max) { where("hour_price BETWEEN #{min} AND #{max}") }
  scope :parking_city, -> (city) { joins(:address).where(" addresses.city = ?", city) }
  
  def self.search(conditions)
    parkings = Parking.all
    if conditions[:kind] == "private"
      parkings = parkings.private_parkings      
    end
    if conditions[:kind] == "public"
      parkings = parkings.public_parkings
    end
    if conditions[:city].present?
      parkings = parkings.parking_city(conditions[:city])
    end 
    if conditions[:day_price_min].present? && conditions[:day_price_max].present?
      parkings = parkings.day_price_in_range(conditions[:day_price_min], conditions[:day_price_max]) 
    end
    if conditions[:hour_price_min].present? && conditions[:hour_price_max].present?
      parkings = parkings.hour_price_in_range(conditions[:hour_price_min], conditions[:hour_price_max]) 
    end
    parkings
  end
    
  private
  
  def set_end_dates_on_place_rents
    self.place_rents.where("end_date > ?", Time.now).each do |place_rent|
      place_rent.end_date = Time.now
      place_rent.save
    end
  end
end
