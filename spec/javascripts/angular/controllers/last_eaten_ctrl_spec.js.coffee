#= require support/expect
#= require support/sinon
#= require angular-mocks

describe 'LastEatenCtrl', ->
  $scope = null
  ctrl = null
  beforeEach(module('Eatme'))
  beforeEach(inject ($rootScope,$controller) ->
    $scope = $rootScope.$new()
    ctrl = $controller('LastEatenCtrl', { $scope: $scope })
  )

  describe 'load()', ->
    _LoadingSvc = null
    _PhotosSvc = null
    beforeEach(inject (LoadingSvc,PhotosSvc) ->
      _LoadingSvc = LoadingSvc
      _PhotosSvc = PhotosSvc
    )

    it 'calls setLoading(true)', ->
      sinon.spy(_LoadingSvc,'setLoading')
      $scope.load()
      expect(_LoadingSvc.setLoading.calledOnce).to.be(true)

    it 'increment currentPage', ->
      $scope.currentPage = 2
      $scope.load()
      expect($scope.currentPage).to.eql(3)

    it 'calls PhotosSvc.last', ->
      sinon.spy(_PhotosSvc,'last')
      $scope.load()
      expect(_PhotosSvc.last.calledOnce).to.be(true)

  describe 'loadMore()', ->
    _LoadingSvc = null
    _PhotosSvc = null
    beforeEach(inject (LoadingSvc,PhotosSvc) ->
      _LoadingSvc = LoadingSvc
      _PhotosSvc = PhotosSvc
    )

    describe 'when loading', ->
      beforeEach ->
        sinon.stub(_LoadingSvc,'isLoading').returns(true)

      it "doesn't load()", ->
        sinon.spy($scope,'load')
        $scope.loadMore()
        expect($scope.load.calledOnce).to.be(false)

    describe 'when not loading', ->
      beforeEach ->
        sinon.stub(_LoadingSvc,'isLoading').returns(false)

      it "calls load()", ->
        sinon.spy($scope,'load')
        $scope.loadMore()
        expect($scope.load.calledOnce).to.be(true)
