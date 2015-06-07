class ShipPositionsController < ApplicationController

  # GET /ship_positions
  # GET /ship_positions.json
  def index
    @positions = ShipPosition.all
  end

  # GET /ship_positions/1
  # GET /ship_positions/1.json
  def show
    @ship = Ship.find(params[:ship_id])
    @positions = ShipPosition.all.where(mmsi: @ship.mmsi)
  end

end
