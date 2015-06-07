json.array!(@cruises) do |cruise|
  json.extract! cruise, :id, :name, :description, :ship_id, :start_at, :end_at
  json.url cruise_url(cruise, format: :json)
end
