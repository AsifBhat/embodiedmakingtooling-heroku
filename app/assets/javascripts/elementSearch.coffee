jQuery ($) ->
  # Defails for all datasets
  datasetDefaults = {
    template: [
      '<p class="content-id">{{elementId}}</p>',
      '<p class="content-description">{{description}}</p>',
    ].join(''),
    engine: Hogan
    ###
      prefetch: {
        # Time to live for data in milliseconds
        ttl: 5000,

        # Transform service result into datums
        filter: (items) ->
          $.map(items, (item) ->
            {
            value: item.elementId,
            elementId: item.elementId,
            description: item.description,
            tokens: (item.elementId + ' ' + item.description).split(' ')
            }
          )
      }
    ###
  }

  generateLocalElements = (elementsList) ->
    importedElements = [];
    Util.log.console(elementsList.length)
    $.each(elementsList, (idx, element) ->
      Util.log.console element
      importedElements.push ({value : element.elementId, elementId: element.elementId, description: element.description, tokens : (element.elementId + element.description).split(' ')})
    )
    Util.log.console(importedElements.length)
    importedElements

  AppContext.grid.activateTypeahead = () ->
    Util.log.console(generateLocalElements(AppContext.vizdata.getElements()).length)
    # Load data sets
    $('#content-search input').typeahead(
      $.extend(true, 
        {
          name: 'stories', 
          local: generateLocalElements(AppContext.vizdata.getElements())
        },
        datasetDefaults
      )
    )

  AppContext.grid.destroyTypeahead = () ->
    Util.log.console 'removing typeahead for inserting new elements'
    $('#content-search input').typeahead('destroy')
