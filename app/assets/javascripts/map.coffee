# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

@getHomeIcon =->
  @homeIcon ?= L.divIcon
    className: 'none'
    html: '<div class="fa fa-home fa-inverse mapicon"></div>'
    size: L.point 22, 22
    iconAnchor: L.point 11, 11

@getShipIcon =->
  @shipIcon ?= L.divIcon
      className: 'none'
      html: '<div class="fa fa-ship fa-inverse mapicon"></div>'
      size: L.point 22, 22
      iconAnchor: L.point 11, 11

@getIconFor = (prop) ->
  if prop.icon == 'home'
    getHomeIcon()
  else
    L.icon
      iconUrl: prop.iconUrl,
      shapUrl: prop.shapeUrl,
      iconSize: [prop.width, prop.length],
      iconAnchor: [prop.width/2, prop.length/2]

L.ShipMarker = L.Marker.extend
  options:
    angle: 0,
    length: 345,
    width: 45,
    minLength: 20,
    iconUrl: '',
    shapeUrl: '',
    iconLength: 0,
    iconWidth: 0,
    realIconUrl: '',
    realIconWidth: 0,
    realIconHeight: 0
  initialize: (latlng, options) ->
    L.Marker.prototype.initialize.call(this, latlng, options)
    this._setupIcon()
  _initIcon: () ->
    this.options.icon = L.icon
      iconUrl: this.options.realIconUrl,
      iconSize: [this.options.realIconWidth, this.options.realIconHeight],
      iconAnchor: [this.options.realIconWidth/2, this.options.realIconHeight/2]
    L.Marker.prototype._initIcon.call(this)
  _setPos: (pos) ->
    if map.getZoom() < 15
      if this.options.icon.options.iconSize[0] != this.options.iconWidth
        this._setupIcon()
        this._initIcon()
    else
      latlon = map.layerPointToLatLng(pos)
      d = 12756274 * Math.PI * Math.cos(latlon.lat / 180 * Math.PI)
      lr = this.options.length / d * 360
      latlon.lng += lr
      pos2 = map.latLngToLayerPoint(latlon)
      iconLength = pos2.x - pos.x
      if this.options.icon.options.iconSize[1] != iconLength
        this._setupShape(iconLength)
        this._initIcon()

    L.Marker.prototype._setPos.call(this, pos)
    if (L.DomUtil.TRANSFORM && map.getZoom() >= 15)
      this._icon.style[L.DomUtil.TRANSFORM] += ' rotate(' + this.options.angle + 'deg)';

  _setupIcon: () ->
    this.options.realIconHeight = this.options.iconHeight
    this.options.realIconWidth = this.options.iconWidth
    this.options.realIconUrl = this.options.iconUrl

  _setupShape: (length) ->
    this.options.realIconHeight = length
    this.options.realIconWidth = length / this.options.length * this.options.width
    this.options.realIconUrl = this.options.shapeUrl
    

L.shipMarker = (pos, options) ->
  new L.ShipMarker(pos, options)

L.RotatedMarker = L.Marker.extend
  options:
    angle: 0
  _setPos: (pos) ->
    L.Marker.prototype._setPos.call(this, pos);
    if (L.DomUtil.TRANSFORM)
      this._icon.style[L.DomUtil.TRANSFORM] += ' rotate(' + this.options.angle + 'deg)';

L.rotatedMarker = (pos, options) ->
  new L.RotatedMarker(pos, options)

$ ->
  if $('#map').length > 0
    window.map = L.map 'map',
      center: [ 0, 0 ],
      zoom: 6,
      zoomControl: false,
      attributionControl: false

    map.on 'resize', (e) ->
      map.options.minZoom = map.getBoundsZoom [[-90,-180],[90,180]], true

    map.options.minZoom = map.getBoundsZoom [[-90,-180],[90,180]], true

    L.tileLayer '//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      attribution: '<a href="//openstreetmap.ch/">OpenStreetMap.org</a> | <a href="http://www.marinetraffic.com/">MarineTraffic</a>',
      maxZoom: 18,
      subdomains: ["a", "b", "c"],
    .addTo(map)
    window.terminator = L.terminator().addTo(map)

    loadGeoJson()
    setInterval loadGeoJson, 60000
    setInterval updateTerminator, 600000

@updateTerminator = ->
  terminator.setTime(Date.now());

@loadGeoJson = ->
  $.ajax
    url: $('#map').attr('data-geojson-url')
    dataType: "json"
    ifModified: true
    error: (jqXHR, textStatus, errorThrown) ->
      console.log "AJAX Error: #{textStatus}"
      console.log jqXHR
      console.log errorThrown
    success: (data, textStatus, jqXHR) ->
      if jqXHR.status != 304
        addGeoJson data

@getGeoJsonLayer =->
  @geoJsonLayer ?= L.geoJson false,
    pointToLayer: (feature, latlng) ->
      if feature.properties.icon == 'home'
        marker = L.marker latlng,
          icon: getHomeIcon()
        return marker
      if feature.properties.icon == 'ship'
        marker = L.shipMarker latlng,
          angle: feature.properties.course,
          iconUrl: feature.properties.iconUrl,
          iconWidth: feature.properties.iconWidth,
          iconHeight: feature.properties.iconHeight,
          shapeUrl: feature.properties.shapeUrl
        marker.options.angle = feature.properties.course;
        marker.bindPopup feature.properties.name
        return marker
    filter: (feature) ->
      if feature.id == 'bbox'
        if !window.setbound
          if feature.geometry.type == 'Point'
            c = L.GeoJSON.coordsToLatLng feature.geometry.coordinates
            map.panTo c
          else
            c = L.GeoJSON.coordsToLatLngs feature.geometry.coordinates[0]
            map.fitBounds c,
              paddingTopLeft: [0, $('.banner').offset().top+$('.banner').height()-$('#map').offset().top]
        window.setbound = true
      feature.id != 'bbox'
  @geoJsonLayer.addTo map
  @geoJsonLayer

@addGeoJson = (data) ->
  getGeoJsonLayer().clearLayers();
  getGeoJsonLayer().addData(data);

