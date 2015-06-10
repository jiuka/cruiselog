require 'date'

class Cruise < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

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

  def linstring
    ship.linstring(start_at, end_at)
  end

  def boundary
    ship.boundary(start_at, end_at)
  end

  def to_features
    entity_factory = ::RGeo::GeoJSON::EntityFactory.instance

    features = []

    features << entity_factory.feature(linstring)

    features << entity_factory.feature(boundary, :bbox, {bbox: true})

    if start_at <= DateTime.now and end_at > DateTime.now
       features << entity_factory.feature(positions.last.to_point, id, {icon: 'ship', name: ship.name, course: positions.last.course})
    end

    features
  end

end
