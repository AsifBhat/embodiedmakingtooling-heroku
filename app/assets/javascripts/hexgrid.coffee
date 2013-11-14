jQuery ($) ->

  appContext.grid.activateListeners = () ->
    # Setting mouse movement related tile events
    appContext.grid.addEvent("tileover", (e, x, y) ->
      appContext.grid.hoverEventHandler(e,x,y)   
    )

    # Tiletap is only fired when not dragging the grid
    appContext.grid.addEvent("tiletap", (e, x, y) ->
      appContext.grid.clickEventHandler(e,x,y)
    )

    
