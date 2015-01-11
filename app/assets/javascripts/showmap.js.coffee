initialize_map = (latitude,longitude) ->
  myLatlng = new google.maps.LatLng(latitude, longitude)
  mapOptions =
    center: myLatlng
    zoom: 16
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)

  new google.maps.Marker(
    position: myLatlng
    map: map
  )

  $("#map-modal").off "shown.bs.modal"
  $("#map-modal").on "shown.bs.modal", ->
    google.maps.event.trigger map, "resize"
    map.setCenter(new google.maps.LatLng(latitude, longitude))


show_map_listener = ->
  $("button.show-map").off "click", ->
  $("button.show-map").on "click", ->
    latitude = $(this).data("latitude")
    longitude = $(this).data("longitude")
    initialize_map(latitude,longitude)

$(document).on "page:change", ->
  show_map_listener()