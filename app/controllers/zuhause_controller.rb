class ZuhauseController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.geojson do
        point = RGeo::Geographic.spherical_factory(srid: 4326).point(9.15109, 47.11596)
        entity_factory = ::RGeo::GeoJSON::EntityFactory.instancoe
        features = entity_factory.feature(point, 'home', {icon: 'home', course: 0})
        render geojson: features, bbox: point
      end
    end
  end
end
