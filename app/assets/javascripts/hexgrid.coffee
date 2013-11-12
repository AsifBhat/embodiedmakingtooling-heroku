jQuery ($) ->


  # Setting mouse movement related tile events
  EM_APP.grid.addEvent("tileover", (e, xc, yc) ->
    # Highlight the currently hovered cell
    pos = {x:xc,y:yc}
    elementUnderMouse = EM_APP.vizdata.getElementInCell(pos)
    if(elementUnderMouse != '')
      # The tooltip info at this stage is just the description.  Later this
      # could be some rich content.
      tooltipinfo = EM_APP.vizdata.getElementDescription(elementUnderMouse)
      EM_APP.grid.showTooltip(xc,yc,tooltipinfo)
    else
      EM_APP.grid.hideTooltip()
    EM_APP.grid.showHoveredElement(xc,yc)    
  )

  # Tiletap is only fired when not dragging the grid
  EM_APP.grid.addEvent("tiletap", (e, x, y) ->

    # Place the element on the grid
    newElement = EM_APP.grid.placeNewElement(x,y)

    # Get pixel position based on grid coordinates
    inv = EM_APP.grid.screenpos(x, y)

    # Keep content search reference
    contentSearch = $("#content-search")

    # Show content search at corrent position
    contentSearch.css({
      "display": "",
      "left": (inv.x + EM_APP.grid.origin.x) + "px",
      "top": (inv.y + EM_APP.grid.origin.y) + "px"
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
          EM_APP.grid.updatePosition(obj, datum.value, dataset, x, y)
        )

        # Clear the previous query
        .typeahead('setQuery', '')

        # Place focus
        .focus()
  )

    
