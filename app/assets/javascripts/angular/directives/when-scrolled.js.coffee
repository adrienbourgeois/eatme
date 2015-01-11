directives = angular.module('directives')

directives.directive 'whenScrolled', ['$window','$document',($window,$document) ->
  return (scope, elm, attr) ->
    getDocHeight = ->
      D = document
      Math.max D.body.scrollHeight, D.documentElement.scrollHeight, D.body.offsetHeight, D.documentElement.offsetHeight, D.body.clientHeight, D.documentElement.clientHeight

    win = angular.element($window)
    win.bind 'scroll', ->
      if win.height() + win.scrollTop() - getDocHeight() > -200
        scope.$apply(attr.whenScrolled)

]