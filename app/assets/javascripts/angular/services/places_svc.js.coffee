services = angular.module('services')

services.factory 'PlacesSvc', ['$http','GeoLocationSvc',($http,GeoLocationSvc) ->
  # This service assume that GeoLocationSvc promise is resolved
  service = {}
  service.promise = GeoLocationSvc.promise

  routes = {
    base: -> "/places"
    index: (latitude,longitude,radius,filterKeyword,page = 0) ->
      "#{routes.base()}/?latitude=#{latitude}&longitude=#{longitude}&radius=#{radius}&filter_keyword=#{filterKeyword}&page=#{page}"
  }

  # Request the photos API to get the last photos
  service.close = (radius,filterKeyword,page) ->
    latitude = GeoLocationSvc.coord.latitude
    longitude = GeoLocationSvc.coord.longitude
    $http.get(routes.index(latitude,longitude,radius,filterKeyword,page)).then(
      (success) ->
        success.data
    )

  return service
]