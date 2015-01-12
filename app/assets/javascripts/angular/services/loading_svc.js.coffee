services = angular.module('services')

services.factory 'LoadingSvc', ['$timeout',($timeout) ->

  service = {}
  loading = true

  # We can put a delay in options. This is used as a nasty trick to wait for an animation to
  # be finished before setting loading to false
  service.setLoading = (val,delay=0) ->
    $timeout(->
      loading = val
    ,delay)

  service.isLoading = ->
    return loading

  return service
]