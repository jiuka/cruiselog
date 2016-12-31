require 'date'
class ShipPosition < ApplicationRecord

  validates :timestamp, presence: true
  validates :speed, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :course, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 360 }, allow_nil: true
  validates :status, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 15 }, allow_nil: true

  def to_point
    factory = ::RGeo::Cartesian.preferred_factory()
    factory.point(position.lon, position.lat)
  end

end
