class Ship < ActiveRecord::Base

  # Validations
  validates :name, presence: true
  validates :mmsi, numericality: true, presence: true
end
