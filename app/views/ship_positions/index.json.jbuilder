json.array!(@ship_positions) do |ship_position|
  json.extract! ship_position, :id, :mmsi, :position, :speed, :course, :status_int, :timestamp
  json.url ship_position_url(ship_position, format: :json)
end
