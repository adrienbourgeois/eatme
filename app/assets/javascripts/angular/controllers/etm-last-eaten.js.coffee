controllers = angular.module('controllers')

controllers.controller 'EtmLastEaten2Ctrl',
['$scope','$timeout','PhotosSvc','MapSvc','LoadingSvc',($scope,$timeout,PhotosSvc,MapSvc,LoadingSvc) ->
  $scope.messageFromController = "hello from controller"

  currentPage = 1

  init = ->
    LoadingSvc.setLoading(true)
    PhotosSvc.last(currentPage).then(
      (photos) ->
        $scope.photos = photos
        LoadingSvc.setLoading(false)
    )

  # Load more pictures (triggered when user reaches the bottom of the page)
  $scope.loadMore = ->
    unless LoadingSvc.isLoading()
      LoadingSvc.setLoading(true)
      currentPage += 1
      PhotosSvc.last(currentPage).then(
        (photos) ->
          $scope.photos = $scope.photos.concat(photos)
          LoadingSvc.setLoading(false,2000)
      )

  # Display a map in a modal with the place location
  $scope.showLocation = (place) ->
    MapSvc.open(place.latitude,place.longitude)

  init()

]
