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

L.RotatedMarker = L.Marker.extend
  options:
    angle: 0
  _setPos: (pos) ->
    L.Marker.prototype._setPos.call(this, pos);
    if (L.DomUtil.TRANSFORM)
      this._icon.firstChild.style[L.DomUtil.TRANSFORM] = 'rotate(' + this.options.angle + 'deg)';

L.rotatedMarker = (pos, options) ->
  new L.RotatedMarker(pos, options)

$ ->
  if $('#map').length > 0
    window.map = L.map 'map'

    map.setView([0, 0], 3)

    L.tileLayer 'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
      attribution: '<a href="//openstreetmap.ch/">OpenStreetMap.org</a> | <a href="http://www.marinetraffic.com/">MarineTraffic</a>',
      maxZoom: 18,
      subdomains: ["a", "b", "c"],
    .addTo(map)
    L.terminator().addTo(map)

    loadGeoJson()
    setInterval loadGeoJson, 60000

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
      marker = L.rotatedMarker latlng,
        icon: getShipIcon()
      marker.options.angle = feature.properties.course;
      marker
    filter: (feature, layer) ->
      if feature.id == 'bbox'
        c = feature.geometry.coordinates[0]
        if !window.setbound
          map.fitBounds [ [ c[0][1], c[0][0]], [c[2][1],c[2][0]]]
        window.setbound = true
      feature.id != 'bbox'
  @geoJsonLayer.addTo map
  @geoJsonLayer

@addGeoJson = (data) ->
  getGeoJsonLayer().clearLayers();
  getGeoJsonLayer().addData(data);

