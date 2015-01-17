#= require support/expect
#= require support/sinon
#= require angular-mocks

describe 'PhotosSvc', ->
  mockBackend = null
  _PhotosSvc = null

  beforeEach(module('Eatme'))
  beforeEach(inject ($httpBackend, PhotosSvc) ->
    mockBackend = $httpBackend
    _PhotosSvc = PhotosSvc
  )

  describe 'close', ->
    it 'calls the right api end point', ->
      mockBackend.expectGET("/photos/?page=1").respond(true)
      _PhotosSvc.last(1)
      mockBackend.flush()

    it 'loads the last photos', ->
      recipes = null
      mockBackend.expectGET("/photos/?page=1").respond([{url:'bla',tags:['pizza']}])
      promise = _PhotosSvc.last(1)
      promise.then (rec) ->
        recipes = rec
      mockBackend.flush()
      expect(angular.equals([{url:'bla',tags:['pizza']}], recipes)).to.be(true)
