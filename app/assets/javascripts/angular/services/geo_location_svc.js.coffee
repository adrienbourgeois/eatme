services = angular.module('services')

services.factory 'GeoLocationSvc', ['$q',($q) ->

  service = {}
  service.coord = {}
  deferred = $q.defer();
  service.promise = deferred.promise;

  if navigator.geolocation
    navigator.geolocation.getCurrentPosition (position) ->
      service.coord.latitude = position.coords.latitude
      service.coord.longitude = position.coords.longitude
      deferred.resolve('Visitor geo localized');
  else
    deferred.reject("We couldn't get the geolocation of the user. Maybe the browser is not compatible with html5 geolocation");

  return service
]