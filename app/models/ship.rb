class Ship < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Relations
  has_many :positions, class_name: "ShipPosition", foreign_key: 'mmsi', primary_key: 'mmsi'

  # Validations
  validates :name, presence: true
  validates :mmsi, numericality: true, presence: true

  # Paper Clips
  has_attached_file :icon
  has_attached_file :shape
  validates_attachment_content_type :icon, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :shape, :content_type => /\Aimage\/.*\Z/
  before_save :extract_dimensions
  serialize :icon_dimensions

  def extract_dimensions
    tempfile = icon.queued_for_write[:original]
    unless tempfile.nil?
      geometry = Paperclip::Geometry.from_file(tempfile)
      self.icon_dimensions = [geometry.width.to_i, geometry.height.to_i]
    end
  end

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
      features << entity_factory.feature(position.position, id, {
        icon: 'ship',
        name: name,
        course: position.course,
        length: length,
        width: width,
        shapeUrl: shape.url,
        iconUrl: icon.url,
        iconWidth: icon_dimensions && icon_dimensions[0] || 64,
        iconHeight: icon_dimensions && icon_dimensions[1] || 10,
      })
    end
    features
  end

end
