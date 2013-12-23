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

    $('body').append('<div id="element_edit" class=" row span4"><div class="row"><div class="row cellTitle"></div><div class"row cellHeader"><h5>Description</h5></div><div class="row cellDesc"></div><hr><div class="row cellControls">&nbsp;<button class="btn btn-mini" disabled  onclick="AppContext.cluster.updateElem($(this))"><span class="icon-pencil"></span>&nbsp;Edit</button>&nbsp;<button class="btn btn-mini"  id="delposButton" disabled><span class="icon-remove remove_btn"></span>&nbsp;Delete</button>&nbsp;<button class="btn btn-mini" disabled  onclick="AppContext.cluster.deleteElem($(this))"><span class="icon-remove"></span>&nbsp;Delete</button></div></div></div>')
    $('#element_edit').prepend('<div id="content-search"><input type="text" id="input-elem-search" name="query"></div>')
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
