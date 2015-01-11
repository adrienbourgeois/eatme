setCookie = (cname, cvalue, exdays) ->
  d = new Date()
  d.setTime(d.getTime() + (exdays*24*60*60*1000))
  expires = "expires="+d.toUTCString()
  document.cookie = cname + "=" + cvalue + "; " + expires

$(document).on "page:change", ->
  if(navigator.geolocation)
    navigator.geolocation.getCurrentPosition (position) ->
      setCookie('latitude',position.coords.latitude,1)
      setCookie('longitude',position.coords.longitude,1)
