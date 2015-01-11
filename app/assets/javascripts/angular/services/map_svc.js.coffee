services = angular.module('services')

services.controller 'MapSvcController', ['$scope','uiGmapGoogleMapApi',($scope,uiGmapGoogleMapApi) ->

  # Little trick to avoid grayness on the google map
  # see: http://stackoverflow.com/questions/24275977/showing-a-google-map-in-angular-ui-modal
  $scope.render = true
  $scope.map = { center: $scope.coord, zoom: 16 }
  $scope.markerId = 1

]

services.factory 'MapSvc', ['$modal','$rootScope',($modal,$rootScope) ->
  service = {}

  service.open = (latitude,longitude) ->
    scope = $rootScope.$new()
    scope.coord = { latitude: latitude, longitude, longitude}
    $modal.open({
      template: "<ui-gmap-google-map ng-if='render' center='map.center' zoom='map.zoom'><ui-gmap-marker idKey='markerId' coords='map.center'></ui-gmap-marker></ui-gmap-google-map>"
      controller: 'MapSvcController'
      size: 'lg'
      scope: scope
    })

  return service
]