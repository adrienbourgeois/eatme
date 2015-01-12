controllers = angular.module('controllers')

controllers.controller 'EtmLastEaten2Ctrl',
['$scope','$timeout','PhotosSvc','MapSvc',($scope,$timeout,PhotosSvc,MapSvc) ->
  $scope.messageFromController = "hello from controller"

  currentPage = 1
  $scope.loading = loading = false

  # Little nasty trick to wait for the animation to complete
  # It would be a lot better to get the promise of the animation and to set loading to false
  # once the animation is complete
  setLoading = (val = false) ->
    $timeout(->
      loading = false
    ,2000)

  init = ->
    loading = true
    PhotosSvc.last(currentPage).then(
      (photos) ->
        $scope.photos = photos
        setLoading()
    )

  # Load more pictures (triggered when user reaches the bottom of the page)
  $scope.loadMore = ->
    unless loading
      loading = true
      currentPage += 1
      PhotosSvc.last(currentPage).then(
        (photos) ->
          $scope.photos = $scope.photos.concat(photos)
          setLoading()
      )

  # Display a map in a modal with the place location
  $scope.showLocation = (place) ->
    MapSvc.open(place.latitude,place.longitude)

  init()

]
