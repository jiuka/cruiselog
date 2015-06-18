class ChangeShipPositionSpeedToFloat < ActiveRecord::Migration
  def change
    change_column :ship_positions, :speed, :float
  end
end
