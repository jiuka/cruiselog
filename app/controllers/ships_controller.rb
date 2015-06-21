class ShipsController < ApplicationController
  before_action :set_ship, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:index, :show]

  # GET /ships
  # GET /ships.json
  def index
    @ships = Ship.all

    @bbox = RGeo::Cartesian.factory.multi_point(@ships.map(&:position).compact.map(&:position)).envelope

    respond_to do |format|
      format.html
      format.geojson { render geojson: @ships, bbox: @bbox }
    end
  end

  # GET /ships/1
  # GET /ships/1.json
  def show
    respond_to do |format|
      format.html
      format.geojson { render geojson: @ship, bbox: @ship.boundary }
    end
  end

  # GET /ships/new
  def new
    @ship = Ship.new
  end

  # GET /ships/1/edit
  def edit
  end

  # POST /ships
  # POST /ships.json
  def create
    @ship = Ship.new(ship_params)

    respond_to do |format|
      if @ship.save
        format.html { redirect_to @ship, notice: 'Ship was successfully created.' }
        format.json { render :show, status: :created, location: @ship }
      else
        format.html { render :new }
        format.json { render json: @ship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ships/1
  # PATCH/PUT /ships/1.json
  def update
    respond_to do |format|
      if @ship.update(ship_params)
        format.html { redirect_to @ship, notice: 'Ship was successfully updated.' }
        format.json { render :show, status: :ok, location: @ship }
      else
        format.html { render :edit }
        format.json { render json: @ship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ships/1
  # DELETE /ships/1.json
  def destroy
    @ship.destroy
    respond_to do |format|
      format.html { redirect_to ships_url, notice: 'Ship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ship
      @ship = Ship.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ship_params
      params.require(:ship).permit(:name, :mmsi, :length, :width, :icon, :shape)
    end
end
