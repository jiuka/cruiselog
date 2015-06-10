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
      this._icon.style[L.DomUtil.TRANSFORM] += ' rotate(' + this.options.angle + 'deg)';
#    else if (L.Browser.ie)
#      rad = this.options.angle * L.LatLng.DEG_TO_RAD, costheta = Math.cos(rad), sintheta = Math.sin(rad);
#      this._icon.style.filter += ' progid:DXImageTransform.Microsoft.Matrix(sizingMethod=\'auto expand\', M11=' +
#              costheta + ', M12=' + (-sintheta) + ', M21=' + sintheta + ', M22=' + costheta + ')';

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
 
$ ->
  $.ajax
    url: $('#map').attr('data-geojson-url')
    dataType: "json"
    error: (jqXHR, textStatus, errorThrown) ->
      $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      window.gl = L.geoJson data,
        pointToLayer: (feature, latlng) ->
          console.log feature
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
      gl.addTo map

@reloadData =->
  $.ajax
    url: window.geoJsonUrl
    dataType: "json"
    ifModified: true
    success: (data, textStatus, jqXHR) ->
      if jqXHR.status == 200
        console.log textStatus, jqXHR
        gl.clearLayers();
        gl.addData(data);

$ ->
  setInterval reloadData, 60000

