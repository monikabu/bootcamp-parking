class AddUniqueConstraintToPlaceRentIdentifier < ActiveRecord::Migration
  def change
    add_index :place_rents, :identifier, unique: true
  end
end
