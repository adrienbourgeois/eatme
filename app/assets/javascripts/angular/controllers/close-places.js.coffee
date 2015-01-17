controllers = angular.module('controllers')

controllers.controller 'ClosePlacesCtrl',
['$scope','$timeout','PlacesSvc','MapSvc','LoadingSvc',($scope,$timeout,PlacesSvc,MapSvc,LoadingSvc) ->
  $scope.currentPage = 1

  $scope.radius = [0.1,0.3,0.6,1.0,1.5,2.0,3.0,5.0]
  $scope.currentRadi = 0.3

  $scope.filterKeywords = [
    '',
    'glutenfree',
    'dessert',
    'bbq',
    'ribs',
    'healthy',
    'pizza',
    'veg',
    'chinese',
    'thai',
    'italian',
    'sea',
    'pancake',
    'icecream',
    'french'
  ]
  $scope.currentFilterKeyword = ''

  $scope.init = ->
    LoadingSvc.setLoading(true)
    $scope.currentPage = 1
    PlacesSvc.close($scope.currentRadi,$scope.currentFilterKeyword,$scope.currentPage).then(
      (places) ->
        console.log 'places'
        console.log places
        $scope.places = places
        LoadingSvc.setLoading(false)
    )

  # Load more pictures (triggered when user reaches the bottom of the page)
  $scope.loadMore = ->
    unless LoadingSvc.isLoading()
      LoadingSvc.setLoading(true)
      $scope.currentPage += 1
      PlacesSvc.close($scope.currentRadi,$scope.currentFilterKeyword,$scope.currentPage).then(
        (places) ->
          $scope.places = $scope.places.concat(places)
          LoadingSvc.setLoading(false,2000)
      )

  $scope.showWarningMessage = ->
    !LoadingSvc.isLoading() && $scope.places && $scope.places.length == 0

  # Display a map in a modal with the place location
  $scope.showLocation = (place) ->
    MapSvc.open(place.latitude,place.longitude)

  PlacesSvc.promise.then(
    (success) ->
      $scope.init()
  )

]
