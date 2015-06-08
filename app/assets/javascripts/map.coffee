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

 
$ ->
  $.ajax
    url: window.geoJsonUrl
    dataType: "json"
    error: (jqXHR, textStatus, errorThrown) ->
      $('body').append "AJAX Error: #{textStatus}"
    success: (data, textStatus, jqXHR) ->
      l = L.geoJson data,
        pointToLayer: (feature, latlng) ->
          L.marker latlng,
            icon: getShipIcon()
      l.addTo map

