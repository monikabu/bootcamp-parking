class AddFieldIdentifierToPlaceRent < ActiveRecord::Migration
  def change
    add_column :place_rents, :identifier, :integer
  end
end
