jQuery ($) ->


  # Setting mouse movement related tile events
  EM_APP.grid.addEvent("tileover", (e, xc, yc) ->
    # Highlight the currently hovered cell
    pos = {x:xc,y:yc}
    elementUnderMouse = EM_APP.vizdata.getElementInCell(pos)
    if(elementUnderMouse!='')
      # elementUnderMouse should be replaced with description
      EM_APP.grid.placeTooltip(xc,yc,elementUnderMouse)
    else
      # $("#desctooltip").tooltip('hide');
    EM_APP.grid.placeHex(hoveredElement,xc,yc)    
  )

  # Tiletap is only fired when not dragging the grid
  EM_APP.grid.addEvent("tiletap", (e, x, y) ->

    # Create new placeholder element to give a visual indication where we will be creating our new element
    newElement = EM_APP.grid.createHex('new')

    # Place the element on the grid
    EM_APP.grid.placeHex(newElement,x,y)

    # Show the new element on the grid
    root.append(newElement)

    # Get pixel position based on grid coordinates
    inv = EM_APP.grid.screenpos(x, y)

    # Keep content search reference
    contentSearch = $("#content-search")

    # Show content search at corrent position
    contentSearch.css({
      "display": "",
      "left": (inv.x + grid.origin.x) + "px",
      "top": (inv.y + grid.origin.y) + "px"
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
          EM_APP.grid.updatePositions(obj, datum.value, dataset,x,y)
        )

        # Clear the previous query
        .typeahead('setQuery', '')

        # Place focus
        .focus()
  )

    
