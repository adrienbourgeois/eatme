controllers = angular.module('controllers')

controllers.controller 'LastEatenCtrl',
['$scope','$timeout','PhotosSvc','MapSvc','LoadingSvc',($scope,$timeout,PhotosSvc,MapSvc,LoadingSvc) ->
  $scope.currentPage = 0
  $scope.photos = []

  $scope.load = ->
    LoadingSvc.setLoading(true)
    $scope.currentPage += 1
    PhotosSvc.last($scope.currentPage).then(
      (photos) ->
        $scope.photos = $scope.photos.concat(photos)
        LoadingSvc.setLoading(false,2000)
    )

  # Load more pictures (triggered when user reaches the bottom of the page)
  $scope.loadMore = ->
    unless LoadingSvc.isLoading()
      $scope.load()

  # Display a map in a modal with the place location
  $scope.showLocation = (place) ->
    MapSvc.open(place.latitude,place.longitude)

  $scope.load()

]
