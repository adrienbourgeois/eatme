app = angular.module("Eatme",
  [
    'ngRoute'
    'controllers'
    'directives'
  ]
)

app.config ($routeProvider) ->
  $routeProvider
    .when '/',
      template: "<div etm-last-eaten></div>"
