AppContext.grid.showProgressBar = (progress_bar, delay) ->
  #progress_bar.show()
  progress = 0
  progBar = (progress, delay) ->
    Util.log.console('in the bar: ' + progress)
    progress_bar.children().css('width', progress+'%')

    if(progress > 90)
      progress_bar.children().css('width', 100+'%');
      return

    progress= progress+ delay
    setTimeout(
      ()-> 
        progBar(progress, delay)
    , delay)

  progBar(progress, delay)

AppContext.grid.showMessageBoard = (message_board, message) ->
  message_board.html(message)

AppContext.grid.fadeItem = (item, fadeTimeout, activateItemCallback) ->
  Util.log.console('Fading in the message items')
  args = Array.prototype.slice.call(arguments, 3)
  item.fadeIn(500)
  activateItemCallback.call(this, item, args[0])
  item.fadeOut(fadeTimeout)
  #item.parent().hide()
