jQuery ($) ->
  # Creating a grid
  gridElement = $('#hexagonal-grid')[0]
  grid = hex.grid(gridElement, {})
  size = hex.size(grid.elem)
  grid.reorient(size.x * 0.5, size.y * 0.5)
  root = $(grid.root)
  deleteClicked = false

  createHex = (styleClass, text = "") ->
    $("<div class='hex' >"+text+"</div>").css({
      "width": grid.tileWidth + "px",
      "height": grid.tileHeight + "px",
      "line-height": grid.tileHeight + "px",
    }).addClass(styleClass)

  placeHex =(elem,x,y) ->
    inv = grid.screenpos(x, y)
    elem.css("left", inv.x + "px")
    elem.css("top", inv.y + "px")

  # Element to show the currently hovered tile
  hoveredElement = createHex('current')
  root.append(hoveredElement)
  idwithtooltip =  $('<div id="desctooltip" data-html="true" data-trigger="focus" style="z-index:1000;width:40px;height:40px;opacity:.5;position:absolute;" data-placement="top" type="button"></div>')
  idwithtooltip.css("width", size + "px")
  idwithtooltip.css("height", size + "px")
  
  # Placing tooltip if not an empty cell
  placeTooltip = (x,y,elementid) ->
    consoleLog 'cell tool tip triggered : ' + elementid
    inv = grid.screenpos(x, y)
    typeind = elementid.substr(0,1)
    switch typeind
     when 'S' then etype = "stories"
     when 'F' then etype = "forces"
     when 'C' then etype = "solutionComponents"
    
    ###
    Get element description by searching vizdata.contentElements
      idwithtooltip.attr("data-original-title",description)
    ###
    idwithtooltip.attr("data-original-title",elementid+"<button style='z-index:1000;font-size:1em;' id='deleteButton' class='btn-mini'><span class='icon-remove remove_btn'></span></button>")
    root.append(idwithtooltip)

    idwithtooltip.css("left", inv.x + "px")
    idwithtooltip.css("top", inv.y+15 + "px")
    #$("#desctooltip").tooltip({delay: 500})
    $("#desctooltip").tooltip('show')
    
    $('.tooltip').mouseenter((e)->
      e.stopPropagation()
      #$("#desctooltip").tooltip('show')
    )
    $('.tooltip').mouseleave((e)->
      e.stopPropagation()
      #$("#desctooltip").tooltip('hide');
    )
    $(".tooltip").click((e) -> 
      #window.deleteContentElement(parseInt(x,10),parseInt(y,10))
      e.stopPropagation()
      consoleLog 'tooltip clicked'
    )
    $("#deleteButton").click((e) -> 
      #window.deleteContentElement(parseInt(x,10),parseInt(y,10))
      e.stopPropagation()
      consoleLog 'delete triggered'
      $("#content-search").css("display","none")
    )


  # Setting mouse movement related tile events
  grid.addEvent("tileover", (e, xc, yc) ->
    # Highlight the currently hovered cell
    pos = {x:xc,y:yc}
    elementUnderMouse = window.getElementInCell(pos)
    if(elementUnderMouse!='')
      placeTooltip(xc,yc,elementUnderMouse)
    else
      # $("#desctooltip").tooltip('hide');
    placeHex(hoveredElement,xc,yc)    
  )

  # Tiletap is only fired when not dragging the grid
  grid.addEvent("tiletap", (e, x, y) ->

    # Create new placeholder element to give a visual indication where we will be creating our new element
    newElement = createHex('new')

    # Place the element on the grid
    placeHex(newElement,x,y)

    # Show the new element on the grid
    root.append(newElement)

    # Get pixel position based on grid coordinates
    inv = grid.screenpos(x, y)

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
          window.updatePositions(obj, datum.value, dataset,x,y)
        )

        # Clear the previous query
        .typeahead('setQuery', '')

        # Place focus
        .focus()
  )

  window.global_vizdata = {}


  placeOnGrid = (elemwithpos) ->
    elemid = elemwithpos.elementId
    
    etype = elemid.substr(0,1)
    switch etype
      when 'S' then cls = "stories"
      when 'F' then cls = "forces"
      when 'C' then cls = "solutionComponents"
    
    #cls = "forces"
    cellToPlace = createHex(cls, elemid)
    root.append(cellToPlace)
    placeHex(cellToPlace,elemwithpos.x,elemwithpos.y)
    

  window.displayAllPositions = (positions) ->
    consoleLog("Displaying all clusters")
    consoleLog(positions)
    $.each(positions, (i, value) ->
      placeOnGrid (value)
    )


  window.consoleLog = (logInfo) ->
    console?.log logInfo
    
