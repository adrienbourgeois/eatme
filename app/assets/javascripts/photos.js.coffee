# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

map = null
marker = null
latitude = 0
longitude = 0

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
  $("a.show_map").on "click", ->
    latitude = $(this).data("latitude")
    longitude = $(this).data("longitude")
    google.maps.event.addDomListener window, "load", initialize()

##################################################################################

appendToCol = (i,obj) ->
  $("#col#{i}").append(obj)

##################################################################################

$ ->

  show_map_listener()

  $("#myModal").on "shown.bs.modal", ->
    google.maps.event.trigger map, "resize"
    map.setCenter(new google.maps.LatLng(latitude, longitude))


  $("#more").on "click", (event) ->
    event.preventDefault()
    appendToCol(0,$("<p>Adrizzzz</p>"))

    $.ajax
      url: "/photos"
      dataType: "json"
      contentType: "application/json"
      success: (ret) ->
        console.log ret
        obj = $("<ul></ul>")
        obj.append($("<li>Adrien</li>"))
        appendToCol(1,obj)

        console.log ret.length

        for i in [0..ret.length-1] by 1
          food_picture = $("<div id='food_picture'></div>")
          image = $("<img src=#{ret[i]['image_low_resolution']}></img><br>")
          food_picture.append(image)
          titre = $("<h3>place.name</h3>")
          food_picture.append(titre)
          row = $("<div class='row'></div>")
          col1 = $("<div class='col-md-6'></div>")
          link1 = $("<a href=#{ret[i]['instagram_url']} target='_blank'><i class='fa fa-instagram fa-3x'></i></a><span>&nbsp;&nbsp;&nbsp; </span>")
          link2 = $("<a href='#' class='show_map' data-toggle='modal' data-target='#myModal' data-latitude='-33.0' data-longitude='151.0' data-place_name='place.name'><i class='fa fa-map-marker fa-3x'></i></a>")
          col1.append(link1)
          col1.append(link2)
          col2 = $("<div class='col-md-6' id='time'></div>")
          minutes_ago = $("<span>#{ret[i]['updated_at']}</span>")
          vicinity = $("<div class='fa'>place.vicinity</div>")
          col2.append(minutes_ago)
          col2.append(vicinity)
          row.append(col1)
          row.append(col2)
          food_picture.append(row)
          appendToCol(i%3,food_picture)

        show_map_listener()

            #.row
            #.col-md-6
            #= minutes_ago photo.updated_at
            #br
            #.fa
            #= place.vicinity


      #$(".panel.panel-info.comment").remove()
      #authorized_user = $(".page-info").data("authorized_user")
      #i = 0

      #while i < ret.length
      #comment = "<div class='panel panel-info comment'><div class='panel-heading'>" + ret[i]["author_email"]
      #comment += "<a class='delete_comment_link' data-comment_id=" + ret[i]["id"] + " href='#'><span class='glyphicon glyphicon-remove' id='float_right'></span></a>"  if authorized_user
      #comment += "<span id='text_date'>" + ret[i]["created_at"] + "&nbsp;</span></div><div class='panel-body'>" + ret[i]["body"] + "</div></div>"
      #$(".comments").append $(comment)
      #i++
      #listen_to_delete()


