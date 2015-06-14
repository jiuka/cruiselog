class AddSourceToShipPosition < ActiveRecord::Migration
  def change
    add_column :ship_positions, :source, :string
  end
end
