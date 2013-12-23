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

    $('body').append('<div id="element_edit" class=" row span4"><div class="row"><div class="row cellTitle"></div><div class"row cellHeader"></div><div class="row cellDesc"></div><hr><div class="row cellControls"><button class="btn btn-mini elementEditBtn" disabled><span class="icon-pencil"></span>&nbsp;Edit</button><button class="btn btn-mini" id="delposButton" disabled><span class="icon-remove remove_btn"></span>Delete Position</button><button class="btn btn-mini deleteAllElements" disabled><span class="icon-remove"></span>Delete Element</button><span id="clickedLocation" style="display: none"></span></div></div></div>')
    
    $('#element_edit').prepend('<div id="content-search"><input type="text" id="input-elem-search" name="query"></div>')
    
    $('.elementEditBtn').click(() ->
      ## show modal window here and let the user edit the content
      editElementModalHTML = '<div id="edit_element_modal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-header"><button type="button" class="close close_title_modal" data-dismiss="modal" aria-hidden="true">&times;</button><h5>Edit</h5></div><div class="modal-body edit_element_text"><textarea class="element_desc" rows=4></textarea></div><div class="modal-footer"><button class="btn btn-warning close_element_modal" data-dismiss="modal" aria-hidden="true">Retain Current</button><button class="btn btn-success" aria-hidden="true" data-dismiss="modal" id="element_title">Change</button></div></div>'
      $('body').append(editElementModalHTML)

      $('#edit_element_modal').modal({
        show: true,
        keyboard: true
      })

      $('.element_desc').val($('.cellDesc').text())

      $('#element_title').click(() ->
        AppContext.cluster.updateElem($('.cellTitle').text())

      )
    )

    $('.deleteAllElements').click(() ->
      idToDelete = $('.cellTitle').text().trim()
      AppContext.cluster.deleteElem(idToDelete)
      $('.cellDesc').text('');
    )
    
    $("#delposButton").click(() -> 
      pos = $('#clickedLocation').text()
      Util.log.console pos
      posArr = pos.split(',')
      AppContext.cluster.deletePosition(posArr[0], posArr[1])
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
