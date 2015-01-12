$ ->
  $(document).on 'click','.navbar-collapse.in', (e) ->
    if $(e.target).is('a')
      $(this).collapse('hide')

  $('.menu li a').click (e) ->
    $this = $(this)
    if !$this.hasClass('active')
      $this.addClass('active')
    e.preventDefault()
