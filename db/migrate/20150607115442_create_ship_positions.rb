class CreateShipPositions < ActiveRecord::Migration
  def change
    create_table :ship_positions do |t|
      t.integer :mmsi
      t.st_point :position, geographic: true
      t.integer :speed
      t.integer :course
      t.integer :status
      t.datetime :timestamp

      t.timestamps null: false
    end
  end
end
