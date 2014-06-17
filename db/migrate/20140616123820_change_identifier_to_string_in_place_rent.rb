class ChangeIdentifierToStringInPlaceRent < ActiveRecord::Migration
  def change
    remove_column :place_rents, :identifier, :integer
    add_column :place_rents, :identifier, :string
  end
end
