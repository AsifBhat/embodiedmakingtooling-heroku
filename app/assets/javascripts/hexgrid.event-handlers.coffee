jQuery ($) ->
  gx = 0
  gy = 0

  

  # Handle the hover event
  AppContext.grid.hoverEventHandler = (e, x, y) ->
    if(AppContext.grid.toDrag != '')
      domelem = $('#'+AppContext.grid.toDrag.posId)
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

  # Method to add position object in the positions array and add the corresponding hex on the grid
  AppContext.grid.addGridPos = (obj, datum, dataset) ->
    # Update the new element
    if( dataset.indexOf('Elements') != -1 )
      dataset = AppContext.vizdata.getContentElementType(datum.value)

    AppContext.grid.newElement.removeClass('new')
    
    #get the position object for the current location
    cellClicked = AppContext.vizdata.getPositionInCell({x: gx, y: gy})

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
    Util.log.console(e)
    $('#element_edit').css({
        display: 'block',
        height: ''
      }
    )
    pos = {x:x,y:y}
    cellClicked = AppContext.vizdata.getPositionInCell(pos);
    #remove the style 'new' from the previous element so it can be added to the newly clicked element
    $('.new').remove()
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
    $('#addFromTypeahead').css("display","none")

    if($('#newElementText').length > 0)
      resetDescSection()

    contentSearch.css({"display": "", 'opacity': 1}).find("input")
        # Remove existing events
        .off('typeahead:selected')
        # Handle selecting content element
        .on('typeahead:selected', AppContext.grid.addGridPos)

        # Clear the previous query
        .typeahead('setQuery', '')

        # Place focus
        .focus()
  
  #AppContext.grid.rightClickEventHandler = ()


  AppContext.grid.hoveroutEventHandler = (e,x,y) ->
    AppContext.grid.hideTooltip()
    
  AppContext.project.handleNameChange = () ->
    $('.proj_title').text(AppContext.vizdata.getProjectTitle())

  AppContext.grid.zoomHandler = (e, x, y) ->
    Util.log.console ('Zoom Event Called')
    # here we have event handlers to the HTML components and other CSS changes
  
  AppContext.grid.tileUpHandler = (e, x, y) ->
    if(AppContext.grid.toDrag!='')
      domelem = $('#'+AppContext.grid.toDragRef.posId)
      $(domelem).removeClass("dragged")    
      AppContext.cluster.deletePosition(AppContext.grid.toDragRef.x,AppContext.grid.toDragRef.y)
      AppContext.cluster.updatePosition(AppContext.grid.toDragRef.elementId, x, y)
      AppContext.grid.toDrag = ''
      AppContext.grid.toDragRef = ''
      AppContext.grid.clonedelem = '' 
      AppContext.grid.toDragRefClone = ''

  AppContext.grid.tileClickHandler = (e, x, y) ->
    e.preventDefault()

  markTobeDragged = (e) ->
    e.preventDefault()
    domelem = $('#'+AppContext.grid.toDrag.posId)
    $(domelem).addClass("dragged")
    $(domelem).removeClass("bordered")
    $(domelem).css("-webkit-clip-path","") 

  AppContext.grid.tileDownHandler = (e, x, y) ->
    console.log("tile clicked")
    pos = {x:x,y:y}
    #e.preventDefault()
    # if (notselectedfrommenu)
    AppContext.grid.toDrag = AppContext.vizdata.getPositionInCell(pos);
    # If a single cell is dragged, toDrag is set as above.  Else(selectedfrommenu) toDrag(s) is /are
    # set by the callbacks of the menu item handler 'Select cluster' etc. 'todragreference' is the 
    # cell from which the dragging is done)
    AppContext.grid.toDragRef = AppContext.vizdata.getPositionInCell(pos)
    if(AppContext.grid.toDrag != '')
      markTobeDragged(e)
      
    
  AppContext.grid.zoomEventHandler = (e, zoomDir) ->
    Util.log.console('Zoom initiated!')
    Util.log.console('Resetting grid:')

    if(AppContext.grid.zoomValue + zoomDir >= 0 && AppContext.grid.zoomValue + zoomDir < AppContext.grid.ZOOM_ARRAY.length )
      # Remove the hex-grid element from the DOM (deactivates the listeners automatically)
      $('#hexagonal-grid').remove()
      # Remove the css file for the grid-sizes
      $('.grid_css').remove()
      # clear the hex-lib cache, to be able to reintialize it again
      AppContext.grid.clearGridCache()

      # get the new Grid CSS file name 'grid-'
      cssFile = '/assets/stylesheets/grid-'

      # Assuming that zoomDir has just 3 values: '1', '-1', '0'
      if(zoomDir != 0)
        AppContext.grid.zoomValue = AppContext.grid.zoomValue + zoomDir
        Util.log.console 'Selected zoom level:'
        Util.log.console AppContext.grid.ZOOM_ARRAY[AppContext.grid.zoomValue]

        if(AppContext.grid.zoomValue >= AppContext.grid.DEFAULT_ZOOM)
          cssFile = cssFile + AppContext.grid.ZOOM_ARRAY[AppContext.grid.zoomValue] + 'x.css'
        else 
          cssFile = cssFile + '1-' + (1/AppContext.grid.ZOOM_ARRAY[AppContext.grid.zoomValue]) + 'x.css'
      else 
        cssFile = cssFile + AppContext.grid.ZOOM_ARRAY[AppContext.grid.DEFAULT_ZOOM] + 'x.css'

      Util.log.console 'Appended file name: '
      Util.log.console cssFile

      #Append the css link element into HTML Head
      $('head').append('<link class="grid_css">')
      $('.grid_css').attr({
        rel:  "stylesheet",
        type: "text/css",
        href: cssFile, 
        class: ''
      })

      # Append the grid element back again, CSS is active on the cells etc for this
      $('body').append('<div id="hexagonal-grid"></div>')

      # Change the dimentions for the hex-grid tiles
      AppContext.grid.grid.tileHeight = AppContext.grid.defaultSize.height * AppContext.grid.ZOOM_ARRAY[AppContext.grid.zoomValue]
      AppContext.grid.grid.tileWidth = AppContext.grid.defaultSize.width * AppContext.grid.ZOOM_ARRAY[AppContext.grid.zoomValue]
      hex.grid.hexagonal.tileWidth = AppContext.grid.grid.tileWidth
      hex.grid.hexagonal.tileHeight = AppContext.grid.grid.tileHeight
      
      AppContext.grid.initApp()

      AppContext.grid.activateListeners()
      AppContext.grid.displayAllPositions(AppContext.vizdata.getPositions())

  dragOnMouseMove = (event) ->
    AppContext.grid.hideTooltip()
    if((AppContext.grid.toDragRefClone == undefined) || (AppContext.grid.toDragRefClone == ''))
      refdomelem =   $('#'+AppContext.grid.toDragRef.posId)
      AppContext.grid.toDragRefClone = $(refdomelem).clone(); 
      $(AppContext.grid.toDragRefClone).prependTo($(refdomelem))
      # make style class
      $(AppContext.grid.toDragRefClone).css("position","fixed")
      $(AppContext.grid.toDragRefClone).css("z-index","1010")
      $(AppContext.grid.toDragRefClone).css("opacity","0.9")
    dx = (event.pageX-20) - $(AppContext.grid.toDragRefClone).position().left
    dy = (event.pageY-20) - $(AppContext.grid.toDragRefClone).position().top    
    newx = $(AppContext.grid.toDragRefClone).position().left + dx
    newy = $(AppContext.grid.toDragRefClone).position().top + dy
    $(AppContext.grid.toDragRefClone).css("left",newx+"px")
    $(AppContext.grid.toDragRefClone).css("top",newy+"px")
    ###
      # clone all toDrag elements
      domelem = $('#'+AppContext.grid.toDrag.posId)
      AppContext.grid.clonedelem = $(domelem).clone()
      $(AppContext.grid.clonedelem).prependTo($(domelem))
      # make style class
      $(AppContext.grid.clonedelem).css("position","fixed")
      $(AppContext.grid.clonedelem).css("z-index","1010")
      $(AppContext.grid.clonedelem).css("opacity","0.9")
      # do for all clonedelems
      newx = $(AppContext.grid.clonedelem).position().left + dx
      newy = $(AppContext.grid.clonedelem).position().top + dy
      $(AppContext.grid.clonedelem).css("left",newx+"px")
      $(AppContext.grid.clonedelem).css("top",newy+"px")
    ###

    

  $( "#hexagonal-grid" ).mousemove( (event) -> 
    if(AppContext.grid.toDrag!='')
      dragOnMouseMove(event)            
  )

  setRightClickedPos = (event) ->
    AppContext.grid.rightClickedPos =  AppContext.grid.getGridPos(event);

  $( "#hexagonal-grid" ).mousedown( (event) -> 
    if(event.which == 3)
      console.log("clicked on div")   
      setRightClickedPos(event)        
  )

