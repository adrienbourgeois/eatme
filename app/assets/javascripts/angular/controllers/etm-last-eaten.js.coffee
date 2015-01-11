controllers = angular.module('controllers')

controllers.controller 'EtmLastEaten2Ctrl', ['$scope','PhotosSvc',($scope,PhotosSvc) ->
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

  init()

]
