#= require support/expect
#= require support/sinon
#= require angular-mocks

describe 'ClosePlacesCtrl', ->
  $scope = null
  ctrl = null
  beforeEach(module('Eatme'))
  beforeEach(inject ($rootScope,$controller) ->
    $scope = $rootScope.$new()
    ctrl = $controller('ClosePlacesCtrl', { $scope: $scope })
  )

  describe 'initialization', ->
    it "sets radius correctly", ->
      expect($scope.radius).to.eql([0.1,0.3,0.6,1.0,1.5,2.0,3.0,5.0])

    it "sets currentRadi", ->
      expect($scope.currentRadi).to.eql(1.5)

    it "sets filterKeywords", ->
      expect($scope.filterKeywords).to.not.be(undefined)


  describe '.init', ->
    _LoadingSvc = null
    _PlacesSvc = null
    beforeEach(inject (LoadingSvc,PlacesSvc) ->
      _LoadingSvc = LoadingSvc
      _PlacesSvc = PlacesSvc
    )

    it 'calls setLoading(true)', ->
      sinon.spy(_LoadingSvc,'setLoading')
      $scope.init()
      expect(_LoadingSvc.setLoading.calledOnce).to.be(true)

    it 'initialize currentPage', ->
      $scope.init()
      expect($scope.currentPage).to.eql(1)

    it 'calls PlacesSvc.close', ->
      sinon.spy(_PlacesSvc,'close')
      $scope.init()
      expect(_PlacesSvc.close.calledOnce).to.be(true)

  describe 'showWarningMessage', ->
    _LoadingSvc = null
    beforeEach(inject (LoadingSvc) ->
      _LoadingSvc = LoadingSvc
    )

    describe 'when it s not loading and there is at least one result', ->
      it 'returns false', ->
        sinon.stub(_LoadingSvc,'isLoading').returns(false)
        $scope.places = [1]
        expect($scope.showWarningMessage()).to.be(false)

    describe 'when it s loading', ->
      it 'returns false', ->
        sinon.stub(_LoadingSvc,'isLoading').returns(true)
        expect($scope.showWarningMessage()).to.be(false)

  describe 'loadMore()', ->
    _LoadingSvc = null
    _PlacesSvc = null
    beforeEach(inject (LoadingSvc,PlacesSvc) ->
      _LoadingSvc = LoadingSvc
      _PlacesSvc = PlacesSvc
    )

    describe 'when loading', ->
      beforeEach ->
        sinon.stub(_LoadingSvc,'isLoading').returns(true)

      it "doesn't calls PlacesSvc.close", ->
        sinon.spy(_PlacesSvc,'close')
        $scope.loadMore()
        expect(_PlacesSvc.close.calledOnce).to.be(false)

    describe 'when not loading', ->
      beforeEach ->
        sinon.stub(_LoadingSvc,'isLoading').returns(false)

      it "set loading to true", ->
        sinon.spy(_LoadingSvc,'setLoading')
        $scope.loadMore()
        expect(_LoadingSvc.setLoading.calledWith(true)).to.be(true)

      it "increment the current page", ->
        $scope.currentPage = 2
        $scope.loadMore()
        expect($scope.currentPage).to.be(3)

      it "calls PlacesSvc.close", ->
        sinon.spy(_PlacesSvc,'close')
        $scope.loadMore()
        expect(_PlacesSvc.close.calledOnce).to.be(true)

  describe 'showLocation', ->
    _MapSvc = null
    beforeEach(inject (MapSvc) ->
      _MapSvc = MapSvc
    )

    it 'calls MapSvc.open with the right args', ->
      sinon.spy(_MapSvc,'open')
      $scope.showLocation({latitude:0.0,longitude:0.0})
      expect(_MapSvc.open.calledWith(0,0)).to.be(true)
      expect(_MapSvc.open.calledOnce).to.be(true)
