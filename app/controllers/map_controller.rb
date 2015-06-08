class MapController < ApplicationController
  def index
    @cruise = Cruise.where('end_at > ? ', Time.now-5.days).order(:start_at).first
    @cruise ||= Cruise.order(:start_at).last

    if @cruise.start_at > DateTime.now and @cruise.end_at > DateTime.now
      @lat = 47.1162
      @lon = 9.1541
      @zoom = 15
      @message = 'Wir sind leider nicht auf Kreuzfahrt'
    else
      @lat = @cruise.ship.position.lat
      @lon = @cruise.ship.position.lon
      @zoom = 3
      @message = @cruise.name
    end
  end

  def show
    @cruise = Cruise.find(params[:id])
    @message = @cruise.name

    @markers = []

    @cruise.positions.each do |p|
      @markers << {:latlng => [p.position.lat, p.position.lon] }
    end
  end

end
