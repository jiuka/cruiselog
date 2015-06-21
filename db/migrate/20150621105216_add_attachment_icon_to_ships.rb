class AddAttachmentIconToShips < ActiveRecord::Migration
  def self.up
    change_table :ships do |t|
      t.attachment :icon
    end
  end

  def self.down
    remove_attachment :ships, :icon
  end
end
