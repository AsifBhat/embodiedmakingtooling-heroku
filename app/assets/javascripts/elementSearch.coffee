jQuery ($) ->
  # Defails for all datasets
  datasetDefaults = {
    ###
    template: [
      '<p class="content-id">{{id}}</p>',
      # '<p class="content-description">{{description}}</p>',
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
    ###
  }

  # Load data sets
  $('#content-search input').typeahead([
    $.extend(true, { name: 'stories', prefetch: {}, local: [ "S0001", "S0002", "S0003", "S0004", "S0005", "S0006", "S0007", "S0008" ] }, datasetDefaults),
    $.extend(true, { name: 'forces', prefetch: {}, local: [ "F0001", "F0002", "F0003", "F0004", "F0005", "F0006", "F0007", "F0008" ] }, datasetDefaults),
    $.extend(true, { name: 'solutionComponents', prefetch: { }, local: [ "C0001", "C0002", "C0003", "C0004", "C0005", "C0006", "C0007", "C0008" ] }, datasetDefaults),
  ])
