jQuery ($) ->

  defaultNuggetDataSet = {
    template: [
      '<p class="content-id">{{nuggetId}}</p>',
      '<p class="nugget-description">{{description}}</p>',
    ].join(''),
    engine: Hogan
  }

  getNuggetTokens = (nuggetList) ->
    nuggetTokens = []
    $.each(nuggetList, (idx, nugget) ->
      nuggetTokens.push({value : nugget.nuggetId, nuggetId: nugget.nuggetId, description: nugget.description, nuggetTokens : (nugget.nuggetId + nugget.description).split(' ')})
    )

  AppContext.grid.initNuggetTypeahead = (nuggetList) ->
    Util.log.console('Intializing Nugget typeahead')
    $('#nugget-search input').typeahead(
      $.extend(true, 
        {
          name: 'Nuggets'+Math.random(), 
          local: getNuggetTokens(nuggetList)
        },
        defaultNuggetDataSet
      )
    )
