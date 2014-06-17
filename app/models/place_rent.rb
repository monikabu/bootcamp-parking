class PlaceRent < ActiveRecord::Base
  before_create :set_identifier
  before_save :calculate_price
  belongs_to :car
  belongs_to :parking
  validates :start_date, :end_date, :parking, :car, presence: true
  scope :current, -> { where("end_date > ? AND start_date < ?", Time.now , Time.now)}
  scope :outdated, -> { where("end_date < ?", Time.now) }

  def to_param
    identifier
  end

  private
  
  def calculate_price
    @number_of_days = ((end_date - start_date)/1.day).floor
    @number_of_hours = ((end_date - start_date) % 1.day)/3600
    self.price = (@number_of_days*parking.day_price + @number_of_hours*parking.hour_price).ceil
  end

  def set_identifier
    record = true
    while record 
      identifier = SecureRandom.hex(5)
      record = self.class.find_by(identifier: identifier)
    end  
    self.identifier = identifier 
  end
end
