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

    $('body').append('<div id="element_edit" class=" row span4"><div class="row"><div class="row cellTitle"></div><div class"row cellHeader"></div><div class="row cellDesc" contenteditable="true"></div><hr><div class="row cellControls"><button class="btn btn-mini" id="delposButton" disabled><span class="icon-remove remove_btn"></span>Delete Position</button><button class="btn btn-mini deleteAllElements" disabled><span class="icon-remove"></span>Delete Element</button><span id="clickedLocation" style="display: none"></span></div></div></div>')
    
    $('#element_edit').prepend('<div id="content-search"><input type="text" id="input-elem-search" name="query"></div>')
    
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
