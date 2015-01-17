#= require angular-mocks

describe 'Controllers', ->
  $scope = null
  ctrl = null
  beforeEach(module('Eatme'))
  beforeEach ->
    this.addMatchers({
      toEqualData: (expected) ->
        return angular.equals(this.actual, expected)
    })

  describe 'ClosePlacesCtrl', ->
    mockBackend = null
    recipe = null
    beforeEach(inject(($rootScope,$controller,_$httpBackend_) ->
      mockBackend = _$httpBackend_
      $scope = $rootScope.$new()
      ctrl = $controller('ClosePlacesCtrl', { $scope: $scope })
    ))

    describe 'initialization', ->
      it "sets radius correctly", ->
        expect($scope.radius).toEqual([0.1,0.3,0.6,1.0,1.5,2.0,3.0,5.0])

      it "sets currentRadi", ->
        expect($scope.currentRadi).toBe(0.3)

      it "sets filterKeywords", ->
        expect($scope.filterKeywords).toBeDefined()

    describe '.init', ->
      _LoadingSvc = null
      _PlacesSvc = null
      beforeEach(inject((LoadingSvc,PlacesSvc) ->
        _LoadingSvc = LoadingSvc
        _PlacesSvc = PlacesSvc
      ))

      it 'calls setLoading(true)', ->
        spyOn(_LoadingSvc,'setLoading')
        $scope.init()
        expect(_LoadingSvc.setLoading).toHaveBeenCalledWith(true)

      it 'initialize currentPage', ->
        $scope.init()
        expect($scope.currentPage).toBe(1)

      it 'calls PlacesSvc.close', ->
        spyOn(_PlacesSvc,'close').andCallThrough()
        $scope.init()
        expect(_PlacesSvc.close).toHaveBeenCalled()


    describe 'showWarningMessage', ->
      _LoadingSvc = null
      beforeEach(inject((LoadingSvc) ->
        _LoadingSvc = LoadingSvc
      ))

      describe 'when it s not loading and there is at least one result', ->
        it 'returns false', ->
          spyOn(_LoadingSvc,'isLoading').andReturn(false)
          $scope.places = [1]
          expect($scope.showWarningMessage()).toBe(false)

      describe 'when it s loading', ->
        it 'returns false', ->
          spyOn(_LoadingSvc,'isLoading').andReturn(true)
          expect($scope.showWarningMessage()).toBe(false)


    describe 'showLocation', ->
      _MapSvc = null
      beforeEach(inject((MapSvc) ->
        _MapSvc = MapSvc
      ))

      it 'calls MapSvc.open with the right args', ->
        spyOn(_MapSvc,'open')
        $scope.showLocation({latitude:0.0,longitude:0.0})
        expect(_MapSvc.open).toHaveBeenCalledWith(0,0)
