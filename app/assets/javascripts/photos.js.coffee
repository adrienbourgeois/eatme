# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

map = null
marker = null
latitude = 0
longitude = 0
latitude_user = 0
longitude_user = 0
page = 1
end = false
first_time = true

getDocHeight = ->
  D = document
  Math.max D.body.scrollHeight, D.documentElement.scrollHeight, D.body.offsetHeight, D.documentElement.offsetHeight, D.body.clientHeight, D.documentElement.clientHeight

load_more_photos = () ->
  #event.preventDefault()
  $.ajax
    url: "/photos?page=#{page}"
    dataType: "json"
    contentType: "application/json"
    success: (ret) ->
      #return true
      if window.location.hash != "#just_eaten"
        return true
      if ret.length%3 isnt 0 or ret.length is 0
        end = true

      for i in [0..ret.length-1]
        li = $("<li></li>")
        image = $("<center><img src=#{ret[i]['image_low_resolution']}></img></center>")
        titre = $("<h3>#{ret[i]['place']['name']}</h3>")
        link2 = $("<div class='vicinity'><button type='button' class='show_map btn btn-default btn-lg' data-toggle='modal' data-target='#myModal' data-latitude=\'#{ret[i]['place']['latitude']}\' data-longitude=\'#{ret[i]['place']['longitude']}\'><span class='glyphicon glyphicon-map-marker'></span></button></div>")
        minutes_ago = $("<div class='time'>#{ret[i]['minutes_ago']}</div>")
        vicinity = $("<div class='vicinity'>#{ret[i]['place']['vicinity']}</div>")
        li. append titre
        li.append image
        li.append minutes_ago
        li.append vicinity
        li.append link2
        $("ul.edgetoedge#gallery").append li
      page++
      show_map_listener()
    beforeSend: ->
      load_more_listener_off()
      $("#spinner_just_eaten")[0].style.display = "inline"
    complete: ->
      load_more_listener_on()
      $("#spinner_just_eaten")[0].style.display = "none"


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
  $("button.show_map").off "click", ->
  $("button.show_map").on "click", ->
    latitude = $(this).data("latitude")
    longitude = $(this).data("longitude")
    google.maps.event.addDomListener window, "load", initialize()

##################################################################################

load_more_photos_when_page_bottom_reached = ->
  if $(window).height() + $(window).scrollTop() - getDocHeight() > -200
    load_more_photos(event)

load_more_listener_on = ->
  $(window).bind("scroll",load_more_photos_when_page_bottom_reached)
  #$("#more").on "click", (event) ->
    #load_more_photos(event)

load_more_listener_off = ->
  $(window).unbind("scroll",load_more_photos_when_page_bottom_reached)
  #$("#more").off "click"

just_eaten = ->
  page_name = $("span.page").data("page_name")
  if page_name is "just_eaten"
    page = 1
    #show_map_listener()
    load_more_listener_off()
    load_more_listener_on()

   $("#myModal").on "shown.bs.modal", ->
      google.maps.event.trigger map, "resize"
      map.setCenter(new google.maps.LatLng(latitude, longitude))

init = ->
  just_eaten()
  get_location()

get_close_places = (rayon) ->
  $.ajax
    url: "/places?latitude=#{latitude_user}&longitude=#{longitude_user}&rayon=#{rayon}"
    dataType: "json"
    contentType: "application/json"
    success: (ret) ->
     $("ul.edgetoedge#close_places").find("li").remove()
     if ret.length == 0
      li = $("<li><center><p>No results found</p></center></li>")
      $("ul.edgetoedge#close_places").append(li)
     else
      for i in [0..ret.length-1]
        li = $("<li></li>")
        name = $("<h3>#{ret[i]['name']}</h3>")
        li.append(name)
        center = $("<center></center>")
        for j in [0..ret[i]['photos'].length-1]
          image = $("<img src=\"#{ret[i]['photos'][j]['image_low_resolution']}\"></img>")
          center.append(image)
        link2 = $("<div class='vicinity'><button type='button' class='show_map btn btn-default btn-lg' data-toggle='modal' data-target='#myModal' data-latitude=\'#{ret[i]['latitude']}\' data-longitude=\'#{ret[i]['longitude']}\'><span class='glyphicon glyphicon-map-marker'></span></button></div>")
        vicinity = $("<div class='vicinity'>#{ret[i]['vicinity']}</div>")
        li.append(center)
        li.append(vicinity)
        li.append(link2)
        $("ul.edgetoedge#close_places").append(li)
      show_map_listener()
    beforeSend: ->
     $("#spinner_close_places")[0].style.display = "inline"
    complete: ->
     $("#spinner_close_places")[0].style.display = "none"


get_location = ->
  #page_name = $("span.page").data("page_name")
  #if page_name is "places_finder"
  if(navigator.geolocation)
    navigator.geolocation.getCurrentPosition (position) ->
      latitude_user = position.coords.latitude
      longitude_user = position.coords.longitude
      console.log "#{latitude},#{longitude}"
      #latitude_user = -33.867589
      #longitude_user = 151.208611
      get_close_places(0.3)
  else
    alert "Impossible to find your location"


$ ->
  if first_time
    init()
    first_time = false

  $("input.rayon").on 'click', ->
    rayon = $(this).val()
    get_close_places(rayon)

  #$(document).on "page:change", ->
    #console.log window.location.pathname
  #load_more_photos()










