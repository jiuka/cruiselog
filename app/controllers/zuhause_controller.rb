class ZuhauseController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.geojson do
        point = current_home
        entity_factory = ::RGeo::GeoJSON::EntityFactory.instance
        features = entity_factory.feature(point, 'home', {icon: 'home'})
        render geojson: features, bbox: point
      end
    end
  end

  def current_home
    if Time.now < Time.new(2016, 11, 14, 12, 0, 0, "+02:00")
      return RGeo::Geographic.spherical_factory(srid: 4326).point(9.15109, 47.11596)
    end
    RGeo::Geographic.spherical_factory(srid: 4326).point(8.48813, 47.38086)
  end
end
