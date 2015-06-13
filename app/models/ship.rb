class Ship < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Relations
  has_many :positions, class_name: "ShipPosition", foreign_key: 'mmsi', primary_key: 'mmsi'

  # Validations
  validates :name, presence: true
  validates :mmsi, numericality: true, presence: true

  def position
    positions.order('timestamp').last
  end

  def linstring(from=DateTime.now-1.week, to=DateTime.now)
    positions.where('timestamp > ? and timestamp < ?', from, to).group(:mmsi).pluck('ST_MakeLine(position::geometry ORDER BY timestamp)').first
  end

  def boundary(from=DateTime.now-1.week, to=DateTime.now)
    positions.where('timestamp > ? and timestamp < ?', from, to).group(:mmsi).pluck('ST_Envelope(ST_MakeLine(position::geometry ORDER BY timestamp))').first
  end
 
  def to_features
    entity_factory = ::RGeo::GeoJSON::EntityFactory.instance
    features = []
    if linstring
      features << entity_factory.feature(linstring)
    end
    if position
      features << entity_factory.feature(position.position, id, {icon: 'ship', name: name, course: position.course})
    end
    features
  end

end
