directives = angular.module('directives')

directives.controller 'SpinnerLoadingCtrl', ['$scope','LoadingSvc',($scope,LoadingSvc) ->
  $scope.isLoading = ->
    LoadingSvc.isLoading()
]

directives.directive 'spinnerLoading', ->
  return {
    restrict: "A"
    controller: 'SpinnerLoadingCtrl'
    template: "<div ng-show='isLoading()' class='spinner-loading'><img src='/assets/spinner555.gif'></div>"
  }
