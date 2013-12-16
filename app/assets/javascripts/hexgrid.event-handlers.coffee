jQuery ($) ->
  gx = 0
  gy = 0
  AppContext.grid.hoverEventHandler = (e, x, y) ->
      # Highlight the currently hovered cell
      pos = {x:x,y:y}
      elementUnderMouse = AppContext.vizdata.getElementInCell(pos)
      if(elementUnderMouse != '')
        # The tooltip info at this stage is just the description.  Later this
        # could be some rich content.
        tooltipInfo = AppContext.vizdata.getElementDescription(elementUnderMouse)
        if(tooltipInfo != '') 
          AppContext.grid.showTooltip(x,y, elementUnderMouse, tooltipInfo)
      AppContext.grid.showHoveredElement(x,y) 

  AppContext.grid.addGridPos = (obj, datum, dataset) ->

    # Update the new element
           
    AppContext.grid.newElement.removeClass('new')
    AppContext.grid.newElement.addClass(dataset)

    # Keep content search reference
    contentSearch = $("#content-search")
    
    # Hide the content search
    contentSearch.css('display', 'none')
    $('#addFromTypeahead').css("display","none");
    AppContext.grid.newElement.text(datum.value) # datum.id later
    AppContext.grid.newElement.css('z-index','100')
    # When a content element is selected from the typeahead, it could be
    # a new entry to the positions list or an update to an already 
    # existing entry.
    AppContext.cluster.updatePosition(datum.value, gx, gy)      

  AppContext.grid.clickEventHandler = (e, x, y) ->
    console.log("here")
    pos = {x:x,y:y}
    cellClicked = AppContext.vizdata.getPositionInCell(pos);
    console.log(cellClicked)
    if(cellClicked == '')
      AppContext.grid.newElement = AppContext.grid.placeNewElement(x,y)
    else
      AppContext.grid.newElement = $('#'+cellClicked.posId)  

    console.log(AppContext.grid.newElement)  

    # Get pixel position based on grid coordinates
    inv = AppContext.grid.grid.screenpos(x, y)

    # Keep content search reference
    contentSearch = $("#content-search")

    gx = x
    gy = y

    # Show content search at corrent position
    $('#addFromTypeahead').css("display","none");
    contentSearch.css({
      "display": "",
      "left": (inv.x + AppContext.grid.grid.origin.x) + "px",
      "top": (inv.y + AppContext.grid.grid.origin.y) + "px"
    }).find("input")
        # Remove existing events
        .off('typeahead:selected')
        # Handle selecting content element
        .on('typeahead:selected', AppContext.grid.addGridPos)

        # Clear the previous query
        .typeahead('setQuery', '')

        # Place focus
        .focus()

  AppContext.grid.hoveroutEventHandler = (e,x,y) ->
    AppContext.grid.hideTooltip()
  
  AppContext.project.handleNameChange = () ->
    $('.proj_title').text(AppContext.vizdata.getProjectTitle());

