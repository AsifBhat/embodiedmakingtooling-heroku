jQuery ($) ->
  appContext.grid.hoverEventHandler = (e, x, y) ->
      # Highlight the currently hovered cell
      pos = {x:x,y:y}
      elementUnderMouse = appContext.vizdata.getElementInCell(pos)
      if(elementUnderMouse != '')
        # The tooltip info at this stage is just the description.  Later this
        # could be some rich content.
        tooltipInfo = appContext.vizdata.getElementDescription(elementUnderMouse)
        appContext.grid.showTooltip(x,y,tooltipInfo)
      else
        appContext.grid.hideTooltip()
      appContext.grid.showHoveredElement(x,y) 

  appContext.grid.clickEventHandler = (e, x, y) ->
    
    # Place the element on the grid
    newElement = appContext.grid.placeNewElement(x,y)

    # Get pixel position based on grid coordinates
    inv = appContext.grid.screenpos(x, y)

    # Keep content search reference
    contentSearch = $("#content-search")

    # Show content search at corrent position
    contentSearch.css({
      "display": "",
      "left": (inv.x + appContext.grid.origin.x) + "px",
      "top": (inv.y + appContext.grid.origin.y) + "px"
    }).find("input")
        # Remove existing events
        .off('typeahead:selected')
        # Handle selecting content element
        .on('typeahead:selected', (obj, datum, dataset) ->

          # Update the new element
                 
          newElement.removeClass('new')
          newElement.addClass(dataset)
          
          # Hide the content search
          contentSearch.css('display', 'none')
          newElement.text(datum.value) # datum.id later
          newElement.css('z-index','100')
          # When a content element is selected from the typeahead, it could be
          # a new entry to the positions list or an update to an already 
          # existing entry.
          appContext.grid.updatePosition(obj, datum.value, dataset, x, y)
        )

        # Clear the previous query
        .typeahead('setQuery', '')

        # Place focus
        .focus()
