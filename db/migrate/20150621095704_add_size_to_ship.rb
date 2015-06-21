class AddSizeToShip < ActiveRecord::Migration
  def change
    add_column :ships, :length, :integer
    add_column :ships, :width, :integer
  end
end
