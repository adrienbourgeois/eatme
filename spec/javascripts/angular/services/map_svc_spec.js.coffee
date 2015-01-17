#= require support/expect
#= require support/sinon
#= require angular-mocks

describe 'MapSvc', ->
  _$modal = null
  _MapSvc = null

  beforeEach(module('Eatme'))
  beforeEach(inject ($modal,MapSvc) ->
    _$modal = $modal
    _MapSvc = MapSvc
  )

  describe 'open', ->
    it 'opens a modal', ->
      sinon.spy(_$modal,'open')
      _MapSvc.open(0.0,0.0)
      expect(_$modal.open.calledOnce).to.be(true)
