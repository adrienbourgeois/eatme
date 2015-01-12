controllers = angular.module('controllers')

controllers.controller 'ClosePlacesCtrl',
['$scope','PlacesSvc','MapSvc',($scope,PlacesSvc,MapSvc) ->
  currentPage = 1
  $scope.loading = loading = false

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
    loading = true
    currentPage = 1
    PlacesSvc.close($scope.currentRadi,$scope.currentFilterKeyword,currentPage).then(
      (places) ->
        console.log 'places'
        console.log places
        $scope.places = places
        loading = false
    )

  # Load more pictures (triggered when user reaches the bottom of the page)
  $scope.loadMore = ->
    unless loading
      loading = true
      currentPage += 1
      PlacesSvc.close($scope.currentRadi,$scope.currentFilterKeyword,currentPage).then(
        (places) ->
          $scope.places = $scope.places.concat(places)
          loading = false
      )

  $scope.showWarningMessage = ->
    $scope.places && $scope.places.length == 0

  # Display a map in a modal with the place location
  $scope.showLocation = (place) ->
    MapSvc.open(place.latitude,place.longitude)

  PlacesSvc.promise.then(
    (success) ->
      $scope.init()
  )

]
