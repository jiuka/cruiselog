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
      @lat = 47.1162
      @lon = 9.1541
      @zoom = 15
      @message = @cruise.name
    end
  end
end
