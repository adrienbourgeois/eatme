services = angular.module('services')

services.factory 'PhotosSvc', ['$http',($http) ->

  service = {}

  routes = {
    base: -> "/photos"
    index: -> "#{routes.base()}"
  }

  # Request the photos API to get the last photos
  service.last = (page) ->
    $http.get(routes.index()).then(
      (success) ->
        success.data
    )

  return service
]