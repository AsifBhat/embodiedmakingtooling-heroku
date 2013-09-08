jQuery ($) ->
  # Defails for all datasets
  datasetDefaults = {
    template: [
      '<p class="content-id">{{id}}</p>',
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
          value: item.id,
          id: item.id,
          description: item.description,
          tokens: (item.id + ' ' + item.description).split(' ')
          }
        )
    }
  }

  # Load data sets
  $('#content-search input').typeahead([
    $.extend(true, { name: 'stories', prefetch: {url: 'api/stories'} }, datasetDefaults),
    $.extend(true, { name: 'forces', prefetch: {url: 'api/forces'} }, datasetDefaults),
    $.extend(true, { name: 'solution components', prefetch: {url: 'api/solutionComponents'} }, datasetDefaults),
  ])
