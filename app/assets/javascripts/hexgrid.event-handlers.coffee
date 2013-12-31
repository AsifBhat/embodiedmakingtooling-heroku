jQuery ($) ->
  gx = 0
  gy = 0
  AppContext.grid.hoverEventHandler = (e, x, y) ->
    if(AppContext.grid.downtile != '')
      domelem = $('#'+AppContext.grid.downtile.posId)
      inv = AppContext.grid.grid.screenpos(x, y)
      domelem.css("left",inv.x)
      domelem.css("top",inv.y)
    else  
      # Highlight the currently hovered cell
      pos = {x:x,y:y}
      elementUnderMouse = AppContext.vizdata.getElementInCell(pos)
      #if(elementUnderMouse != '')
      # The tooltip info at this stage is just the description.  Later this
      # could be some rich content.
      #tooltipInfo = AppContext.vizdata.getElementDescription(elementUnderMouse)
      #if(tooltipInfo != '') 
      #  AppContext.grid.showTooltip(x,y, elementUnderMouse, tooltipInfo)
    AppContext.grid.showHoveredElement(x,y) 

  AppContext.grid.addGridPos = (obj, datum, dataset) ->
    # Update the new element
    if( dataset.indexOf('Elements') != -1 )
      dataset = AppContext.vizdata.getContentElementType(datum.value)

    AppContext.grid.newElement.removeClass('new')
    
    #get the position object for the current location
    cellClicked = AppContext.vizdata.getPositionInCell({x: gx, y: gy});

    if(cellClicked != '')
      AppContext.grid.newElement = $('#'+cellClicked.posId)
      AppContext.grid.newElement.removeClass('stories')
      AppContext.grid.newElement.removeClass('forces')
      AppContext.grid.newElement.removeClass('solutionComponents')
  
      # Clear any previous text associated with the current hex-cell
      AppContext.grid.newElement.text('')

    AppContext.grid.newElement.addClass(dataset)

    # Keep content search reference
    contentSearch = $("#content-search")
    
    # Hide the content search
    contentSearch.css('display', 'none')
    $('#addFromTypeahead').css("display","none");
    
    # Add the corresponding text to the given element
    AppContext.grid.newElement.text(datum.value) # datum.id later
    AppContext.grid.newElement.css('z-index','100')
    # When a content element is selected from the typeahead, it could be
    # a new entry to the positions list or an update to an already 
    # existing entry.
    AppContext.cluster.updatePosition(datum.value, gx, gy)

    # when new cell is added, update the edit section
    tooltipInfo = AppContext.vizdata.getElementDescription(datum.value)
    AppContext.grid.drawTipDesc(datum.value , tooltipInfo, {x: gx, y:gy})

  AppContext.grid.clickEventHandler = (e, x, y) ->
    $('#element_edit').css({
        display: 'block',
        height: ''
      }
    )
    pos = {x:x,y:y}
    cellClicked = AppContext.vizdata.getPositionInCell(pos);
    #remove the style 'new' from the previous element so it can be added to the newly clicked element
    $('.new').removeClass('new')
    if(cellClicked == '')
      AppContext.grid.newElement = AppContext.grid.placeNewElement(x,y)
    else
      AppContext.grid.newElement = $('#'+cellClicked.posId)  

    # Get pixel position based on grid coordinates
    inv = AppContext.grid.grid.screenpos(x, y)

    elementUnderMouse = AppContext.vizdata.getElementInCell(pos)
    if(elementUnderMouse != '')
      # The tooltip info at this stage is just the description.  Later this
      # could be some rich content.
      tooltipInfo = AppContext.vizdata.getElementDescription(elementUnderMouse)
      $('.cellControls > button').removeAttr('disabled')
    else
      tooltipInfo = ''
      $('.cellControls > button').attr('disabled', '')

    AppContext.grid.drawTipDesc(elementUnderMouse , tooltipInfo, pos)

    # Keep content search reference
    contentSearch = $("#content-search")

    gx = x
    gy = y

    # Show content search at current position
    $('#addFromTypeahead').css("display","none");
    ###
      contentSearch.css({
        "display": "",
        "left": (inv.x + AppContext.grid.grid.origin.x) + "px",
        "top": (inv.y + AppContext.grid.grid.origin.y) + "px"
      })
    ###
    contentSearch.css({"display": "", 'opacity': 1}).find("input")
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
    
    
  $( "#hexagonal-grid" ).mousemove( (event) -> 
    if(AppContext.grid.downtile!='')
      AppContext.grid.hideTooltip()
      if(AppContext.grid.clonedelem == '')
        domelem = $('#'+AppContext.grid.downtile.posId)
        AppContext.grid.clonedelem = $(domelem).clone()
        $(AppContext.grid.clonedelem).prependTo($(domelem))
        $(AppContext.grid.clonedelem).css("position","fixed")
        $(AppContext.grid.clonedelem).css("z-index","1010")
        $(AppContext.grid.clonedelem).css("opacity","0.9")
      $(AppContext.grid.clonedelem).css("left",event.pageX-20)
      $(AppContext.grid.clonedelem).css("top",event.pageY-20)      
  );  

