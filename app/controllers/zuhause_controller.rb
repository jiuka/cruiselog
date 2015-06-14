class ZuhauseController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.geojson do
        entity_factory = ::RGeo::GeoJSON::EntityFactory.instance
        features = entity_factory.feature(
          RGeo::Geographic.spherical_factory(srid: 4326).point(9.15134, 47.11601),
          'home', {icon: 'home', course: 0})
        render geojson: features, bbox: RGeo::Geographic.spherical_factory(srid: 4326).point(9.15134, 47.11601)
      end
    end
  end
end
