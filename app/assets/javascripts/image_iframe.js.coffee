$(document).on 'click', '.scrolloff', (e) ->
  $(this).removeClass('scrolloff')
  $(this).one 'mouseout', (e) ->
    $(this).addClass('scrolloff')
