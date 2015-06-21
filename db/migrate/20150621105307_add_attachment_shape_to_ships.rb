class AddAttachmentShapeToShips < ActiveRecord::Migration
  def self.up
    change_table :ships do |t|
      t.attachment :shape
    end
  end

  def self.down
    remove_attachment :ships, :shape
  end
end
