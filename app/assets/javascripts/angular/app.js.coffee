services = angular.module('services',[])
directives = angular.module('directives',[])
controllers = angular.module('controllers',[])

app = angular.module("Eatme",
  [
    'ngRoute'
    'ngAnimate'
    'ngMock'
    'ui.bootstrap'
    'uiGmapgoogle-maps'
    'services'
    'directives'
    'controllers'
  ]
)

app.config ($routeProvider,$httpProvider,uiGmapGoogleMapApiProvider) ->
  $routeProvider
    .when '/lastly_eaten',
      controller: 'EtmLastEaten2Ctrl'
      templateUrl: '/assets/etm_last_eaten.html'
    .when '/close_places',
      controller: 'ClosePlacesCtrl'
      templateUrl: '/assets/close_places.html'
    .otherwise
      redirectTo: '/lastly_eaten'

  $httpProvider.defaults.headers.common['Accept'] = "application/json"
  $httpProvider.defaults.headers.common['Content-Type'] = "application/json"

  uiGmapGoogleMapApiProvider.configure({
    # key: 'your api key',
    v: '3.17',
    libraries: 'weather,geometry,visualization'
  })