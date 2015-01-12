services = angular.module('services')

services.factory 'PlacesSvc', ['$http','GeoLocationSvc',($http,GeoLocationSvc) ->
  # This service assume that GeoLocationSvc promise is resolved

  service = {}
  deferred = $q.defer();
  service.promise = deferred.promise;


  routes = {
    base: -> "/places"
    index: (latitude,longitude,page = 0) -> "#{routes.base()}/?latitude=#{latitude}&longitude=#{longitude}&page=#{page}"
  }

  # Request the photos API to get the last photos
  service.close = (page) ->
    latitude = GeoLocationSvc.coord.latitude
    longitude = GeoLocationSvc.coord.longitude
    $http.get(routes.index(latitude,longitude,page)).then(
      (success) ->
        success.data
    )

  return service
]