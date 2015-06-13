ActionController::Renderers.add :geojson do |obj, options|
  factory = ::RGeo::GeoJSON::EntityFactory.instance
  if obj.kind_of?(RGeo::GeoJSON::Feature)
    RGeo::GeoJSON.encode(factory.feature_collection([obj].flatten)).to_json
  elsif obj.respond_to?(:to_features)
    RGeo::GeoJSON.encode(factory.feature_collection([obj.to_features].flatten)).to_json
  elsif obj.respond_to?(:map)
    RGeo::GeoJSON.encode(factory.feature_collection(obj.map(&:to_features).flatten)).to_json
  else
    obj.class.to_s
  end
end
