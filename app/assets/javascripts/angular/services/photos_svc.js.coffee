services = angular.module('services')

services.factory 'PhotosSvc', ['$http',($http) ->

  service = {}

  routes = {
    base: -> "/photos"
    index: (page = 0) -> "#{routes.base()}/?page=#{page}"
  }

  # Request the photos API to get the last photos
  service.last = (page) ->
    $http.get(routes.index(page)).then(
      (success) ->
        success.data
    )

  return service
]