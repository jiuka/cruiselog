require 'date'

class Cruise < ActiveRecord::Base

  # Relations
  belongs_to :ship

  # Validations
  validates :name, presence: true
  validates :ship, presence: true
  validate :start_must_be_before_end

  def start_must_be_before_end
    if end_at <= start_at
      errors.add(:start_at, "must be before end")
      errors.add(:end_at, "must be after start")
    end
  end

  def positions
    ship.positions.where('timestamp > ? and timestamp < ?', start_at, end_at).order(:timestamp)
  end

  def to_geojson
    entity_factory = ::RGeo::GeoJSON::EntityFactory.instance
    factory = ::RGeo::Cartesian.preferred_factory()

    features = []

    features << entity_factory.feature(factory.line_string(positions.map(&:to_point)))

    if start_at <= DateTime.now and end_at > DateTime.now
       features << entity_factory.feature(positions.last.to_point, id, {icon: 'ship', name: ship.name})
    end

    RGeo::GeoJSON.encode(entity_factory.feature_collection(features))
  end

end
