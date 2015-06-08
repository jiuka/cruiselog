class ShipPosition < ActiveRecord::Base

  def to_point
    factory = ::RGeo::Cartesian.preferred_factory()
    factory.point(position.lon, position.lat)
  end

end
