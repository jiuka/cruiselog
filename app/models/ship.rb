class Ship < ActiveRecord::Base

  # Relations
  has_many :positions, class_name: "ShipPosition", foreign_key: 'mmsi', primary_key: 'mmsi'

  # Validations
  validates :name, presence: true
  validates :mmsi, numericality: true, presence: true

  def position
    positions.order('timestamp').last.position
  end
end
