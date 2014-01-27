jQuery ($) ->
  gx = 0
  gy = 0
  AppContext.grid.toDrag = []
  AppContext.grid.clonesToDrag = []

  

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

  # Callback that handles VALUES_ADDED event on the Vizdatamodel positions object for each value added
  AppContext.grid.posValueAddedCallback = (addedPos) ->
    AppContext.grid.placeOnGrid(addedPos)  

  # Callback that handles VALUES_REMOVED event on the Vizdatamodel positions object for each value removed
  AppContext.grid.posValueRemovedCallback = (addedPos) ->
    AppContext.grid.removeFromGrid(addedPos)    

  # Method to add position object in the positions array and add the corresponding hex on the grid
  AppContext.grid.addGridPos = (obj, datum, dataset) ->
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
  
  AppContext.grid.hoveroutEventHandler = (e,x,y) ->
    AppContext.grid.hideTooltip()
    
  AppContext.project.handleNameChange = () ->
    $('.proj_title').text(AppContext.vizdata.getProjectTitle())

  AppContext.grid.tileUpHandler = (e, x, y) ->
    if(AppContext.grid.toDrag.length != 0)
      domelem = $('#'+AppContext.grid.toDragRef.posId)
      $(domelem).removeClass("dragged")    
      deltax = x - AppContext.grid.toDragRef.x
      deltay = y - AppContext.grid.toDragRef.y
      AppContext.cluster.deletePosition(AppContext.grid.toDragRef.x,AppContext.grid.toDragRef.y)
      AppContext.cluster.updatePosition(AppContext.grid.toDragRef.elementId, AppContext.grid.toDragRef.x+deltax, AppContext.grid.toDragRef.y+deltay)
      $.each(AppContext.grid.toDrag, (i,todrag) ->
        if(todrag.posId != AppContext.grid.toDragRef.posId)
          AppContext.cluster.deletePosition(todrag.x, todrag.y)
          AppContext.cluster.updatePosition(todrag.elementId, todrag.x+deltax, todrag.y+deltay)
      )
      AppContext.grid.toDrag = []
      AppContext.grid.toDragRef = ''
      AppContext.grid.clonesToDrag = [] 
      AppContext.grid.toDragRefClone = ''
      AppContext.grid.selectedElemPos  = []

  AppContext.grid.tileClickHandler = (e, x, y) ->
    e.preventDefault()

  AppContext.grid.markTobeDragged = () ->
    $.each(AppContext.grid.toDrag, (i, todrag) ->
      domelem = $('#'+todrag.posId)
      $(domelem).addClass("dragged")
    )

  AppContext.grid.tileDownHandler = (e, x, y) ->
    if (AppContext.grid.selectedElemPos == undefined) || (AppContext.grid.selectedElemPos.length == 0)
      pos = {x:x,y:y}
      elempos = AppContext.vizdata.getPositionInCell(pos)
      if(elempos!='')
        AppContext.grid.toDrag = []
        AppContext.grid.toDrag.push(elempos)
      # If a single cell is dragged, toDrag is set as above.  Else(selectedfrommenu) toDrag(s) is /are
      # set by the callbacks of the menu item handler 'Select cluster' etc. 'todragreference' is the 
      # cell from which the dragging is done)
        AppContext.grid.toDragRef = AppContext.vizdata.getPositionInCell(pos)
    else
      AppContext.grid.toDrag = AppContext.grid.selectedElemPos
      AppContext.grid.toDragRef = AppContext.grid.rightClickedelempos
    if(AppContext.grid.toDrag.length > 0)    
      AppContext.grid.markTobeDragged()
      e.preventDefault()
    
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
    if(AppContext.grid.toDragRef!='')&&(AppContext.grid.toDragRef != undefined) #&& (AppContext.grid.todrag!=undefined)&&(AppContext.grid.todrag.length > 0)
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


    if(AppContext.grid.toDrag.length>1)
      clonedelem = ''
      if((AppContext.grid.clonesToDrag.length == 0))
        $.each(AppContext.grid.toDrag, (i, todrag) ->
          if(todrag.posId != AppContext.grid.toDragRef.posId)
            domelem = $('#'+todrag.posId)
            clonedelem = $(domelem).clone()
            $(clonedelem).prependTo($(domelem))
            $(clonedelem).css("position","fixed")
            $(clonedelem).css("z-index","1010")
            $(clonedelem).css("opacity","0.9")
            AppContext.grid.clonesToDrag.push(clonedelem)
        )
      $.each(AppContext.grid.clonesToDrag, (i, todragclone) ->
        newx = $(todragclone).position().left + dx
        newy = $(todragclone).position().top + dy
        $(todragclone).css("left",newx+"px")
        $(todragclone).css("top",newy+"px")
      )
      

  AppContext.grid.mousemovehandler = (event) ->
    if(AppContext.grid.toDrag!='')
      dragOnMouseMove(event)            


  isInArray = (elem, array)  ->
    toreturn = false
    $.each(array, (i, member) ->
      if(member.posId == elem.posId)
        toreturn = true
    )
    toreturn

  AppContext.grid.markSelected = () ->
    $.each(AppContext.grid.selectedElemPos, (i,sel) ->
      domelem = $('#'+sel.posId)
      $(domelem).css("opacity", "0.5")
    )

  getCluster = (nbelemcells, startIndex)  ->
    currentIndex = startIndex
    $.each(nbelemcells, (i,nbelemcell) ->
      if(i>=startIndex)
        nbcells = AppContext.grid.getAllNeighbourCells({x:nbelemcell.x, y:nbelemcell.y})
        $.each(nbcells, (j, nbcell) ->
          newnbelemcell = AppContext.vizdata.getPositionInCell(nbcell)
          if((newnbelemcell != '')&&(!isInArray(newnbelemcell,nbelemcells)))
            nbelemcells.push(newnbelemcell)
        )
      currentIndex = i  
    )
    if(currentIndex < nbelemcells.length-1) 
      getCluster(nbelemcells, currentIndex+1)
    else
      nbelemcells  

  AppContext.grid.selectCluster = (e) ->
    nbelemcells = []
    rightClickedelempos = AppContext.vizdata.getPositionInCell(AppContext.grid.rightClickedPos)
    if(rightClickedelempos != '')
      nbelemcells.push(rightClickedelempos)  
    AppContext.grid.selectedElemPos = getCluster(nbelemcells,0)
    AppContext.grid.rightClickedelempos = rightClickedelempos
    AppContext.grid.toDrag = []
    AppContext.grid.markSelected()
    

  setRightClickedPos = (event) ->
    AppContext.grid.rightClickedPos =  AppContext.grid.getGridPos(event);
    console.log(AppContext.grid.rightClickedPos)

  AppContext.grid.mousedownhandler = (event) ->
    if(event.which)
      if(event.which == 3)
        setRightClickedPos(event)        
    else if (even.button)    
      if(event.button == 3)
        setRightClickedPos(event)
    
  AppContext.controls.handleNuggetDisplay= (evt) ->
    Util.log.console('Handling nugget display click')

    # Toggle display for the edit pane: The click should effect the visiblity of the pane
    # The following is a temporary setup, once the whole edit section is moved to the pane 
    # the following toggle has to be removed.
    if( $('#edit_pane').css('display') == 'none')
      $('#edit_pane').css('display', 'block')
      AppContext.grid.addNuggetSection()
    else 
      if $('.edit_nuggets').css('display') == 'none'
        #$('.desc_section').css('display', 'none')
        AppContext.grid.addNuggetSection()
      else 
        $('.cont_edit_pane').css('display', 'none')


  $( "#hexagonal-grid" ).mousemove( (event) -> 
    if(AppContext.grid.downtile!='')
      AppContext.grid.hideTooltip()
      if(AppContext.grid.clonedelem == '')
        domelem = $('#'+AppContext.grid.downtile.posId)
        $(domelem).removeClass("bordered")
        $(domelem).css("-webkit-clip-path","")
        AppContext.grid.clonedelem = $(domelem).clone()
        $(AppContext.grid.clonedelem).prependTo($(domelem))
        $(AppContext.grid.clonedelem).css("position","fixed")
        $(AppContext.grid.clonedelem).css("z-index","1010")
        $(AppContext.grid.clonedelem).css("opacity","0.9")
      $(AppContext.grid.clonedelem).css("left",event.pageX-20)
      $(AppContext.grid.clonedelem).css("top",event.pageY-20)      
  )
