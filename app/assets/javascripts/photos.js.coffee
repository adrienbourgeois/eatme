# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

map = null
marker = null
latitude = 0
longitude = 0
page = 2

getDocHeight = ->
  D = document
  Math.max D.body.scrollHeight, D.documentElement.scrollHeight, D.body.offsetHeight, D.documentElement.offsetHeight, D.body.clientHeight, D.documentElement.clientHeight

load_more_photos = (event) ->
  event.preventDefault()

  $.ajax
    url: "/photos?page=#{page}"
    dataType: "json"
    contentType: "application/json"
    success: (ret) ->
      console.log ret
      for i in [0..ret.length-1] by 1
        food_picture = $("<div id='food_picture'></div>")
        image = $("<img src=#{ret[i]['image_low_resolution']}></img><br>")
        food_picture.append(image)
        titre = $("<h3>#{ret[i]['place']['name']}</h3>")
        food_picture.append(titre)
        row = $("<div class='row'></div>")
        col1 = $("<div class='col-md-6'></div>")
        link1 = $("<a href=#{ret[i]['instagram_url']} target='_blank'><i class='fa fa-instagram fa-3x'></i></a><span>&nbsp;&nbsp;&nbsp; </span>")
        link2 = $("<a href='#' class='show_map' data-toggle='modal' data-target='#myModal' data-latitude=\'#{ret[i]['place']['latitude']}\' data-longitude=\'#{ret[i]['place']['longitude']}\'><i class='fa fa-map-marker fa-3x'></i></a>")
        col1.append(link1)
        col1.append(link2)
        col2 = $("<div class='col-md-6' id='time'></div>")
        minutes_ago = $("<span>#{ret[i]['updated_at']}</span>")
        vicinity = $("<div class='fa'>#{ret[i]['place']['vicinity']}</div>")
        col2.append(minutes_ago)
        col2.append(vicinity)
        row.append(col1)
        row.append(col2)
        food_picture.append(row)
        appendToCol(i%3,food_picture)

      page++
      show_map_listener()
    beforeSend: ->
      load_more_listener_off()
      $(".pretty_button").find("span").remove()
      spinner = $("<img src='assets/spiffygif_30x30.gif'></img>")
      $(".pretty_button").append(spinner)
    complete: ->
      load_more_listener_on()
      button_text = $("<span>More</span>")
      $(".pretty_button").append(button_text)
      $(".pretty_button").find("img").remove()



##################################################################################

initialize = ->
  myLatlng = new google.maps.LatLng(latitude, longitude)
  mapOptions =
    center: myLatlng
    zoom: 16
    mapTypeId: google.maps.MapTypeId.ROADMAP

  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)

  marker = new google.maps.Marker(
    position: myLatlng
    map: map
  )

##################################################################################

show_map_listener = ->
  $("a.show_map").off "click", ->
  $("a.show_map").on "click", ->
    latitude = $(this).data("latitude")
    longitude = $(this).data("longitude")
    google.maps.event.addDomListener window, "load", initialize()

##################################################################################

appendToCol = (i,obj) ->
  $("#col#{i}").append(obj)

##################################################################################

load_more_photos_when_page_bottom_reached = ->
  if $(window).height() + $(window).scrollTop()is getDocHeight()
    load_more_photos(event)

load_more_listener_on = ->
  $(window).bind("scroll",load_more_photos_when_page_bottom_reached)
  $("#more").on "click", (event) ->
    load_more_photos(event)

load_more_listener_off = ->
  $(window).unbind("scroll",load_more_photos_when_page_bottom_reached)
  $("#more").off "click"

$ ->

  show_map_listener()
  load_more_listener_on()

  $("#myModal").on "shown.bs.modal", ->
    google.maps.event.trigger map, "resize"
    map.setCenter(new google.maps.LatLng(latitude, longitude))







