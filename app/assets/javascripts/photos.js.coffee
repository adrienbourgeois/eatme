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
      if window.location.hash != "#just_eaten"
        return true
      if ret.length%3 isnt 0 or ret.length is 0
        end = true

      for i in [0..ret.length-1]
        li = $("<li></li>")
        image = $("<center><img src=#{ret[i]['image_low_resolution']}></img></center>")
        titre = $("<h3>#{ret[i]['place']['name']}</h3>")
        link2 = $("<div class='vicinity'><button type='button' class='show_map btn btn-default btn-lg' data-toggle='modal' data-target='#myModal' data-latitude=\'#{ret[i]['place']['latitude']}\' data-longitude=\'#{ret[i]['place']['longitude']}\'><span class='glyphicon glyphicon-map-marker'></span></button></div>")

          #<a href='#' class='show_map' data-toggle='modal' data-target='#myModal' data-latitude=\'#{ret[i]['place']['latitude']}\' data-longitude=\'#{ret[i]['place']['longitude']}\'><i class='fa fa-map-marker fa-3x'></i></a>")
        minutes_ago = $("<div class='time'>#{ret[i]['minutes_ago']}</div>")
        vicinity = $("<div class='vicinity'>#{ret[i]['place']['vicinity']}</div>")
        li. append titre
        li.append image
        li.append minutes_ago
        li.append vicinity
        li.append link2
        $("ul.edgetoedge#gallery").append li

      #for j in [0..ret.length-1] by 3
        #main_row = $("<div class='row'></div>")
        #for i in [j..j+2]
          #food_picture = $("<div class='food_picture_container'></div>")
          #image = $("<img src=#{ret[i]['image_low_resolution']} class='food_picture'></img><br>")
          #food_picture.append(image)
          #titre = $("<h3>#{ret[i]['place']['name']}</h3>")
          #food_picture.append(titre)
          #row = $("<div class='row'></div>")
          #col1 = $("<div class='col-md-6'></div>")
          #link1 = $("<a href=#{ret[i]['instagram_url']} target='_blank'><i class='fa fa-instagram fa-3x'></i></a><span>&nbsp;&nbsp;&nbsp; </span>")
          #link2 = $("<a href='#' class='show_map' data-toggle='modal' data-target='#myModal' data-latitude=\'#{ret[i]['place']['latitude']}\' data-longitude=\'#{ret[i]['place']['longitude']}\'><i class='fa fa-map-marker fa-3x'></i></a>")
          #col1.append(link1)
          #col1.append(link2)
          #col2 = $("<div class='col-md-6' id='time'></div>")
          #minutes_ago = $("<span>#{ret[i]['updated_at']}</span>")
          #vicinity = $("<div class='fa'>#{ret[i]['place']['vicinity']}</div>")
          #col2.append(minutes_ago)
          #col2.append(vicinity)
          #row.append(col1)
          #row.append(col2)
          #food_picture.append(row)
          #main_col = $("<div class='col-md-4'></div>")
          #main_col.append(food_picture)
          #main_row.append(main_col)
        #$("#photos_grid").append(main_row)
      page++
      show_map_listener()
    beforeSend: ->
      load_more_listener_off()
      #$(".pretty_button").find("span").remove()
      #spinner = $("<img src='assets/spiffygif_30x30.gif'></img>")
      #$(".pretty_button").append(spinner)
    complete: ->
      load_more_listener_on()
      #button_text = $("<span>More</span>")
      #$(".pretty_button").append(button_text)
      #$(".pretty_button").find("img").remove()
      #if end
        #$(".pretty_button").remove()



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










