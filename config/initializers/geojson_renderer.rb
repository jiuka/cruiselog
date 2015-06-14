ActionController::Renderers.add :geojson do |obj, options|
  factory = ::RGeo::GeoJSON::EntityFactory.instance

  features = []

  if options.has_key? :bbox
    features << factory.feature(options[:bbox],  'bbox', {bbox: true})
  end

  if obj.kind_of?(RGeo::GeoJSON::Feature)
    features << obj
  elsif obj.respond_to?(:to_features)
    features << obj.to_features
  elsif obj.respond_to?(:map)
    features << obj.map(&:to_features)
  end

  if features.length > 0
    RGeo::GeoJSON.encode(factory.feature_collection(features.flatten)).to_json
  else
    obj.class.to_s
  end
end
