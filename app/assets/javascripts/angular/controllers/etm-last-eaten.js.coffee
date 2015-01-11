controllers = angular.module('controllers')

controllers.controller 'EtmLastEaten2Ctrl', ['$scope','PhotosSvc',($scope,PhotosSvc) ->
  $scope.messageFromController = "hello from controller"

  PhotosSvc.last(0).then(
    (photos) ->
      $scope.photos = photos
  )
]
