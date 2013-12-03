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
rayon_gv = -1

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

##################################################################################

getDocHeight = ->
  D = document
  Math.max D.body.scrollHeight, D.documentElement.scrollHeight, D.body.offsetHeight, D.documentElement.offsetHeight, D.body.clientHeight, D.documentElement.clientHeight

load_more_photos_when_page_bottom_reached = ->
  if $(window).height() + $(window).scrollTop() - getDocHeight() > -200
    if window.location.hash == "#just_eaten" && !end_just_eaten && !loading
      just_eaten_loading(event)
    if window.location.hash == "#close_places" && rayon_gv != -1 && !end_close_places
      close_places_loading(rayon_gv)

load_more_listener_on = ->
  $(window).bind("scroll",load_more_photos_when_page_bottom_reached)

load_more_listener_off = ->
  $(window).unbind("scroll",load_more_photos_when_page_bottom_reached)

##################################################################################

close_places_loading = (rayon) ->
  $.ajax
    url: "/places?page=#{page_close_places}&latitude=#{latitude_user}&longitude=#{longitude_user}&rayon=#{rayon}"
    dataType: "json"
    contentType: "application/json"
    success: (ret) ->
     if ret.length == 0
       if page_close_places == 1
        li = $("<li><center><p>No results found</p></center></li>")
        $("ul.edgetoedge#close_places").append(li)
       else
        end_close_places = true
     else
      for i in [0..ret.length-1]
        li = $("<li></li>")
        name = $("<h3>#{ret[i]['name']}</h3>")
        li.append(name)
        center = $("<center></center>")
        for j in [0..ret[i]['photos'].length-1]
          image = $("<img src=\"#{ret[i]['photos'][j]['image_thumbnail']}\"></img>")
          center.append(image)
        link2 = $("<div class='vicinity'><button type='button' class='show_map btn btn-default btn-lg' data-toggle='modal' data-target='#myModal' data-latitude=\'#{ret[i]['latitude']}\' data-longitude=\'#{ret[i]['longitude']}\'><span class='glyphicon glyphicon-map-marker'></span></button></div>")
        vicinity = $("<div class='vicinity'>#{ret[i]['vicinity']}</div>")
        li.append(center)
        li.append(vicinity)
        li.append(link2)
        $("ul.edgetoedge#close_places").append(li)
      page_close_places++
      show_map_listener()
    beforeSend: ->
     loading = true
     load_more_listener_off()
     $("#spinner_close_places")[0].style.display = "inline"
    complete: ->
     load_more_listener_on()
     $("#spinner_close_places")[0].style.display = "none"
     loading = false

##################################################################################

just_eaten_loading = ->
  $.ajax
    url: "/photos?page=#{page_just_eaten}"
    dataType: "json"
    contentType: "application/json"
    success: (ret) ->
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
        show_map_listener()
    beforeSend: ->
      loading = true
      $("button.show_place").off 'click'
      load_more_listener_off()
      $("#spinner_just_eaten")[0].style.display = "inline"
    complete: ->
      load_more_listener_on()
      loading = false
      $("#spinner_just_eaten")[0].style.display = "none"
      $("button.show_place").on 'click', ->
        id = $(this).data("place_id")
        show_place(id)

##################################################################################

close_places = (rayon)->
  $("ul.edgetoedge#close_places").find("li").remove()
  $("#spinner_close_places")[0].style.display = "inline"
  if(navigator.geolocation)
    navigator.geolocation.getCurrentPosition (position) ->
      latitude_user = position.coords.latitude
      longitude_user = position.coords.longitude
      console.log "#{latitude},#{longitude}"
      #latitude_user = -33.867589
      #longitude_user = 151.208611
      close_places_loading(rayon)
  else
    alert "Impossible to find your location"

##################################################################################

show_place = (id) ->
  window.location.href = "#show_place"
  console.log "==========#{$(".asasdfasdf").length}"
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
      center = $("<center></center>")
      for j in [0..ret['photos'].length-1]
        image = $("<img src=\"#{ret['photos'][j]['image_low_resolution']}\"></img>")
        center.append(image)
      link2 = $("<div class='vicinity'><button type='button' class='show_map btn btn-default btn-lg' data-toggle='modal' data-target='#myModal' data-latitude=\'#{ret['latitude']}\' data-longitude=\'#{ret['longitude']}\'><span class='glyphicon glyphicon-map-marker'></span></button></div>")
      vicinity = $("<div class='vicinity'>#{ret['vicinity']}</div>")
      li.append(center)
      li.append(vicinity)
      li.append(link2)
      $("ul.edgetoedge#show_place").append(li)
     show_map_listener()
    beforeSend: ->
     $("ul.edgetoedge#show_place").find("li").remove()
     $("#spinner_show_place")[0].style.display = "inline"
    complete: ->
     $("#spinner_show_place")[0].style.display = "none"

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
          name = $("<span>#{ret[i]['name']} (#{ret[i]['photos'].length})</span>")
          button = $("<div class='vicinity'><button type='button' class='show_place btn btn-default btn-lg' data-place_id=#{ret[i]['id']}><span class='glyphicon glyphicon-arrow-right'></span></button></div>")
          col1.append(name)
          col2.append(button)
          row.append(col1)
          row.append(col2)
          li.append(row)
          $("ul.edgetoedge#popular_places").append(li)
      beforeSend: ->
        $("#spinner_popular_places")[0].style.display = "inline"
        $("button.show_place").off 'click'
      complete: ->
        $("#spinner_popular_places")[0].style.display = "none"
        $("button.show_place").on 'click', ->
          id = $(this).data("place_id")
          show_place(id)

##################################################################################

$ ->
  close_places(0.3)

  $("input.rayon").on 'click', ->
    end_close_places = false
    rayon = $(this).val()
    page_close_places = 1
    close_places(rayon)
    rayon_gv = rayon

  $("#myModal").on "shown.bs.modal", ->
    google.maps.event.trigger map, "resize"
    map.setCenter(new google.maps.LatLng(latitude, longitude))

  $(window).on 'hashchange', ->
    anchor = window.location.hash
    console.log $(location).attr('href')
    if anchor is "#just_eaten"
      if last_page != "#show_place"
        end_just_eaten = false
        page_just_eaten = 1
        $("ul.edgetoedge#gallery").find("li").remove()
      just_eaten_loading()

    if anchor is "#popular_places"
      popular_places()
    last_page = anchor

