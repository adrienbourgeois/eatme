page = 1

load_more_photos_mobile = ->
  $.ajax
    url: "/photos?page=#{page}"
    dataType: "json"
    contentType: "application/json"
    success: (ret) ->
      alert "go"
      for i in [0..ret.length-1]
        li = $("<li></li>")
        image = $("<center><img src=#{ret[i]['image_low_resolution']}></img></center>")
        vicinity = $("<p>#{ret[i]['place']['vicinity']}</p>")
        li.append(image)
        li.append(vicinity)
        $("div#just_eaten").find('ul.edgetoedge').append(li)
    beforeSend: ->
    complete: ->
      page += 1

init_mobile = ->
  $("a#just_eaten_link").on 'click', ->
    page = 1
    $("div#just_eaten").find('ul.edgetoedge').find("li").remove()
    load_more_photos_mobile()
  $("#more").on 'click', (event) ->
    event.preventDefault()
    load_more_photos_mobile()


$ ->
  init_mobile()
  #$(document).on "page:change", mobile_f

