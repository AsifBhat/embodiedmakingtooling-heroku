jQuery ($) ->
  # Defails for all datasets
  datasetDefaults = {
    template: [
      '<p class="content-id">{{elementId}}</p>',
      '<p class="content-description">{{description}}</p>',
    ].join(''),
    engine: Hogan
  }

  
    
  generateLocalElements = (elementsList) ->
    importedElements = [];
    $.each(elementsList, (idx, element) ->
      importedElements.push ({value : element.elementId, elementId: element.elementId, description: element.description, tokens : (element.elementId + element.description).split(' ')})
    )
    importedElements

  AppContext.grid.activateTypeahead = (elementList) ->
    # Load data sets
    #<input type="text" name="query">
    #$('#content-search').append('<input type="text" name="query">')

    #$('body').append('<div id="element_edit" class=" row span4"><div class="row"><div class="row cellTitle"></div><div class"row cellHeader"></div><div class="row cellDesc" contenteditable="true"></div><hr><div class="row cellControls"><button class="btn btn-mini" id="delposButton" disabled><span class="icon-remove remove_btn"></span>Delete Position</button><button class="btn btn-mini deleteAllElements" disabled><span class="icon-remove"></span>Delete Element</button><span id="clickedLocation" style="display: none"></span></div></div></div>')

    $('body').append('<div class="accordion span4" id="element_edit"><div class="accordion-group"><div class="accordion-heading text-center"><h5 class="accordion-toggle cellHeader" data-toggle="collapse" data-parent="#element_edit" href="#collapseOne"></h5></div><div id="collapseOne" class="accordion-body collapse in" style="overflow : visible;"><div class="accordion-inner"><div id="element_edit_container" class="row"><div class="row edit_inner"><span class="cellTitle" style="display: none"></span><div class="row cellDesc" contenteditable="true"></div><hr><div class="row cellControls"><button class="btn btn-mini" id="delposButton" disabled><span class="icon-remove remove_btn"></span>Delete Position</button>&nbsp; <button class="btn btn-mini deleteAllElements" disabled><span class="icon-remove"></span>Delete Element</button><span id="clickedLocation" style="display: none"></span></div></div></div></div></div></div></div>')
    
    $('#element_edit').collapse('show')

    $('#element_edit').on('hidden', () ->
      $('#element_edit').css('overflow', 'hidden')
      $('#collapseOne').css('overflow', 'hidden')
      AppContext.grid.drawMakingSummary()
      # count all individual stories etc and show the count on the header
    )

    $('#element_edit').on('shown', () ->
      $('#element_edit').css('overflow', 'visible')
      $('#collapseOne').css('overflow', 'visible')
      AppContext.grid.drawTipHeader($('.cellTitle').text())
      # display the ID of the current element being edited
    )

    $('#element_edit_container').prepend('<div id="content-search"><input type="text" id="input-elem-search" name="query"></div>')
    
    $('.cellDesc').keypress((e) ->
      if (e.which == 13)
        e.preventDefault()
        Util.log.console 'Printing element discription'
        Util.log.console($(this).text())
        Util.log.console('Entery pressed')
        AppContext.cluster.updateElem($('.cellTitle').text(), $('.cellDesc').text())
    )

    $('.deleteAllElements').click(() ->
      idToDelete = $('.cellTitle').text().trim()
      AppContext.cluster.deleteElem(idToDelete)
      $('.cellTitle').text('');
      $('.cellDesc').text('');
    )
    
    $("#delposButton").click(() -> 
      pos = $('#clickedLocation').text()
      Util.log.console pos
      posArr = pos.split(',')
      AppContext.cluster.deletePosition(posArr[0], posArr[1])
      $('.cellTitle').text('');
      $('.cellDesc').text('');
    )

    $('#content-search').keypress((evt) ->
      handleKeyPress(evt)
    ) 
    $('#content-search input').typeahead(
      $.extend(true, 
        {
          name: 'stories', 
          local: generateLocalElements(elementList)
        },
        datasetDefaults
      )
    )

  AppContext.grid.reloadTypeahead = (elementList)  ->
    $('#content-search input').typeahead('destroy');
    $('#content-search input').typeahead(
      $.extend(true, 
        {
          name: 'stories'+Math.random(), 
          local: generateLocalElements(elementList)
        },
        datasetDefaults
      )
    )
    Util.log.console("Reloaded")
    Util.log.console(elementList)
