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
    ship.positions.where('timestamp > ? and timestamp < ?', start_at, end_at)
  end
        
end
