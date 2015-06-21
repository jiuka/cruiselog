class AddHeadingToShipPosition < ActiveRecord::Migration
  def change
    add_column :ship_positions, :heading, :integer
  end
end
