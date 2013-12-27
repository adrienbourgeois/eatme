# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

map = null
marker = null
latitude = 0
longitude = 0
latitude_user = 0
longitude_user = 0
page_just_eaten = 1
page_close_places = 1
end_just_eaten = false
end_close_places = false
loading = false
last_page = ''
radius_gv = -1

##################################################################################

initialize_map = ->
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

show_map_listener = ->
  $("button.show_map").off "click", ->
  $("button.show_map").on "click", ->
    latitude = $(this).data("latitude")
    longitude = $(this).data("longitude")
    google.maps.event.addDomListener window, "load", initialize_map()

show_place_listener = ->
  $("button.show_place").off 'click'
  $("button.show_place").on 'click', ->
    id = $(this).data("place_id")
    show_place(id)

refresh_listeners = ->
  show_map_listener()
  show_place_listener()

spinner_on = (spinner_id) ->
  $(spinner_id)[0].style.display = "inline"

spinner_off = (spinner_id) ->
  $(spinner_id)[0].style.display = "none"


##################################################################################

getDocHeight = ->
  D = document
  Math.max D.body.scrollHeight, D.documentElement.scrollHeight, D.body.offsetHeight, D.documentElement.offsetHeight, D.body.clientHeight, D.documentElement.clientHeight

load_more_photos_when_page_bottom_reached = ->
  if $(window).height() + $(window).scrollTop() - getDocHeight() > -200
    if window.location.hash == "#just_eaten" && !end_just_eaten && !loading
      just_eaten_loading(event)
    if window.location.hash == "#close_places" && radius_gv != -1 && !end_close_places
      close_places_loading(radius_gv)

load_more_listener_on = ->
  $(window).bind("scroll",load_more_photos_when_page_bottom_reached)
  loading = false

load_more_listener_off = ->
  loading = true
  $(window).unbind("scroll",load_more_photos_when_page_bottom_reached)

##################################################################################

close_places_loading = (radius) ->
  $.ajax
    url: "/places?page=#{page_close_places}&latitude=#{latitude_user}&longitude=#{longitude_user}&radius=#{radius}"
    dataType: "json"
    contentType: "application/json"
    success: (ret) ->
     if ret.length == 0
       if page_close_places == 1
        li = $("<li><center><p>No results found</p></center></li>")
        $("ul.edgetoedge#close_places").append(li)
       end_close_places = true
     else
      for i in [0..ret.length-1]
        li = $("<li></li>")
        name = $("<h3>#{ret[i]['name']}</h3>")
        li.append(name)
        center = $("<div></div>")
        content = $("<div id='content'></div>")
        center.append(content)
        imgs_list = $("<div class='imgs' data-current_img=0></div>")
        content.append(imgs_list)
        for j in [0..ret[i]['photos'].length-1]
          image = $("<img src=\"#{ret[i]['photos'][j]['image_low_resolution']}\"></img>")
          imgs_list.append(image)
        link2 = $("<div class='vicinity'><button type='button' class='show_map btn btn-default btn-lg' data-toggle='modal' data-target='#myModal' data-latitude=\'#{ret[i]['latitude']}\' data-longitude=\'#{ret[i]['longitude']}\'><span class='glyphicon glyphicon-map-marker'></span></button></div>")
        vicinity = $("<div class='vicinity'>#{ret[i]['vicinity']}</div>")
        li.append(center)
        li.append(vicinity)
        li.append(link2)
        $("ul.edgetoedge#close_places").append(li)
      page_close_places++
      show_map_listener()
    beforeSend: ->
     load_more_listener_off()
     spinner_on("#spinner_close_places")
    complete: ->
     spinner_off("#spinner_close_places")
     load_more_listener_on()
     listen_to_swipe()

##################################################################################

just_eaten_loading = ->
  $.ajax
    url: "/photos?page=#{page_just_eaten}"
    dataType: "json"
    contentType: "application/json"
    success: (ret) ->
      console.log ret
      if ret.length is 0
        end_just_eaten = true
      else
        for i in [0..ret.length-1]
          li = $("<li></li>")
          image = $("<center><img src=#{ret[i]['image_low_resolution']}></img></center>")
          titre = $("<h3>#{ret[i]['place']['name']}</h3>")
          button = $("<div class='vicinity'></div>")
          link2 = $("<div class='vicinity'><button type='button' class='show_map btn btn-default btn-lg' data-toggle='modal' data-target='#myModal' data-latitude=\'#{ret[i]['place']['latitude']}\' data-longitude=\'#{ret[i]['place']['longitude']}\'><span class='glyphicon glyphicon-map-marker'></span></button> <button type='button' class='show_place btn btn-default btn-lg' data-place_id=#{ret[i]['place']['id']}><span class='glyphicon glyphicon-arrow-right'></span></button></div>")
          minutes_ago = $("<div class='time'>#{ret[i]['minutes_ago']}</div>")
          vicinity = $("<div class='vicinity'>#{ret[i]['place']['vicinity']}</div>")
          li. append titre
          li.append image
          li.append minutes_ago
          li.append vicinity
          li.append link2
          $("ul.edgetoedge#gallery").append li
        page_just_eaten++
    beforeSend: ->
      load_more_listener_off()
      spinner_on("#spinner_just_eaten")
    complete: ->
      spinner_off("#spinner_just_eaten")
      refresh_listeners()
      load_more_listener_on()

##################################################################################

close_places = (radius)->
  $("ul.edgetoedge#close_places").find("li").remove()
  spinner_on("#spinner_close_places")
  if(navigator.geolocation)
    navigator.geolocation.getCurrentPosition (position) ->
      latitude_user = position.coords.latitude
      longitude_user = position.coords.longitude
      close_places_loading(radius)
  else
    alert "Impossible to find your location"

##################################################################################

show_place = (id) ->
  window.location.href = "#show_place"
  $.ajax
    url: "/places/#{id}"
    dataType: "json"
    contentType: "application/json"
    success: (ret) ->
     if ret.length == 0
      li = $("<li><center><p>No results found</p></center></li>")
      $("ul.edgetoedge#show_place").append(li)
     else
      li = $("<li></li>")
      name = $("<h3>#{ret['name']}</h3>")
      li.append(name)
      center = $("<div></div>")
      content = $("<div id='content'></div>")
      center.append(content)
      imgs_list = $("<div class='imgs' data-current_img=0></div>")
      content.append(imgs_list)
      for j in [0..ret['photos'].length-1]
      #for j in [0..2]
        image = $("<img src=\"#{ret['photos'][j]['image_low_resolution']}\"></img>")
        imgs_list.append(image)
      link2 = $("<div class='vicinity'><button type='button' class='show_map btn btn-default btn-lg' data-toggle='modal' data-target='#myModal' data-latitude=\'#{ret['latitude']}\' data-longitude=\'#{ret['longitude']}\'><span class='glyphicon glyphicon-map-marker'></span></button></div>")
      vicinity = $("<div class='vicinity'>#{ret['vicinity']}</div>")
      li.append(center)
      li.append(vicinity)
      li.append(link2)
      $("ul.edgetoedge#show_place").append(li)
    beforeSend: ->
     $("ul.edgetoedge#show_place").find("li").remove()
     spinner_on("#spinner_show_place")
    complete: ->
     show_map_listener()
     spinner_off("#spinner_show_place")
     listen_to_swipe()


##################################################################################

popular_places = ->
  if $("ul.edgetoedge#popular_places").find("li").length is 0
    $.ajax
      url: "/places?page=popular"
      dataType: "json"
      contentType: "application/json"
      success: (ret) ->
        for i in [0..ret.length-1]
          li = $("<li></li>")
          row = $("<div class='row'></div>")
          col1 = $("<div class='col-sm-9'></div>")
          col2 = $("<div class='col-sm-3'></div>")
          name = $("<span>#{ret[i]['name']}</span>")
          button = $("<div class='vicinity'><button type='button' class='show_place btn btn-default btn-lg' data-place_id=#{ret[i]['id']}><span class='glyphicon glyphicon-arrow-right'></span></button></div>")
          col1.append(name)
          col2.append(button)
          row.append(col1)
          row.append(col2)
          li.append(row)
          $("ul.edgetoedge#popular_places").append(li)
      beforeSend: ->
        spinner_on("#spinner_popular_places")
      complete: ->
        spinner_off("#spinner_popular_places")
        show_place_listener()

##################################################################################

$ ->

  close_places(0.3)
  listen_to_swipe();

  $("select#distance").change ->
    radius = $(this).val()
    end_close_places = false
    page_close_places = 1
    close_places(radius)
    radius_gv = radius

  $("#myModal").on "shown.bs.modal", ->
    google.maps.event.trigger map, "resize"
    map.setCenter(new google.maps.LatLng(latitude, longitude))

  $(window).on 'hashchange', ->
    anchor = window.location.hash
    if anchor is "#just_eaten"
      if last_page != "#show_place"
        end_just_eaten = false
        page_just_eaten = 1
        $("ul.edgetoedge#gallery").find("li").remove()
        just_eaten_loading()

    if anchor is "#popular_places"
      popular_places()
    last_page = anchor

