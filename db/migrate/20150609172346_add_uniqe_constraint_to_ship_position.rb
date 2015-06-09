class AddUniqeConstraintToShipPosition < ActiveRecord::Migration
  def change
    add_index :ship_positions, [:mmsi, :timestamp], :unique => true
  end
end
