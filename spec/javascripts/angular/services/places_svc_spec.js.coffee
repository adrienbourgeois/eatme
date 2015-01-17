#= require support/expect
#= require support/sinon
#= require angular-mocks

describe 'PlacesSvc', ->
  mockBackend = null
  _PlacesSvc = null
  _GeoLocationSvc = null

  beforeEach(module('Eatme'))
  beforeEach ->
    this.addMatchers({
      toEqualData: (expected) ->
        return angular.equals(this.actual, expected)
    })
  beforeEach(inject ($httpBackend, PlacesSvc, GeoLocationSvc) ->
    mockBackend = $httpBackend
    _PlacesSvc = PlacesSvc
    _GeoLocationSvc = GeoLocationSvc
  )

  describe 'close', ->
    beforeEach ->
      _GeoLocationSvc.coord = { latitude: -30.0, longitude: 181.0 }

    it 'calls the right api end point', ->
      mockBackend.expectGET("/places/?latitude=-30&longitude=181&radius=3&filter_keyword=pizza&page=1").respond(true)
      _PlacesSvc.close(3.0,'pizza',1)
      mockBackend.flush()

    it 'loads the close places', ->
      recipes = null
      mockBackend.expectGET("/places/?latitude=-30&longitude=181&radius=3&filter_keyword=pizza&page=1").respond([{name:'Adriatic Restaurant'}])
      promise = _PlacesSvc.close(3.0,'pizza',1)
      promise.then (rec) ->
        recipes = rec
      mockBackend.flush()
      expect(angular.equals([{name:'Adriatic Restaurant'}], recipes)).to.be(true)
