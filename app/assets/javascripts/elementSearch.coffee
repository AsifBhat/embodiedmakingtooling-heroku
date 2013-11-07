jQuery ($) ->
  # Defails for all datasets
  datasetDefaults = {
    template: [
      '<p class="content-id">{{elementId}}</p>',
      '<p class="content-description">{{description}}</p>',
    ].join(''),
    engine: Hogan,
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
  }

  # Load data sets
  $('#content-search input').typeahead([
    $.extend(true, { name: 'stories', prefetch: {url: '/assets/javascripts/sampleElements.json'} }, datasetDefaults),
  ])