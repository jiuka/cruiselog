class AddIconDimentionToShip < ActiveRecord::Migration
  def change
    add_column :ships, :icon_dimensions, :string
  end
end
