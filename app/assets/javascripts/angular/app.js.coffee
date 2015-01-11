services = angular.module('services',[])
directives = angular.module('directives',[])
controllers = angular.module('controllers',[])

app = angular.module("Eatme",
  [
    'ngRoute'
    'services'
    'directives'
    'controllers'
  ]
)

app.config ($routeProvider,$httpProvider) ->
  $routeProvider
    .when '/lastly_eaten',
      controller: 'EtmLastEaten2Ctrl'
      templateUrl: '/assets/etm_last_eaten.html'
    .otherwise
      redirectTo: '/lastly_eaten'

  $httpProvider.defaults.headers.common['Accept'] = "application/json"
  $httpProvider.defaults.headers.common['Content-Type'] = "application/json"
