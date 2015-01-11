controllers = angular.module('controllers')

controllers.controller 'EtmLastEaten2Ctrl',
['$scope','PhotosSvc','MapSvc',($scope,PhotosSvc,MapSvc) ->
  $scope.messageFromController = "hello from controller"

  currentPage = 1
  $scope.loading = loading = false

  init = ->
    loading = true
    PhotosSvc.last(currentPage).then(
      (photos) ->
        $scope.photos = photos
        loading = false
    )

  # Load more pictures (triggered when user reaches the bottom of the page)
  $scope.loadMore = ->
    unless loading
      loading = true
      currentPage += 1
      PhotosSvc.last(currentPage).then(
        (photos) ->
          $scope.photos = $scope.photos.concat(photos)
          loading = false
      )

  # Display a map in a modal with the place location
  $scope.showLocation = (place) ->
    MapSvc.open(place.latitude,place.longitude)

  init()

]
