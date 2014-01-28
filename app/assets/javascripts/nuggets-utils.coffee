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

  # add the typeahead and a listing mechanism for the nuggets
  AppContext.grid.addNuggetSection = () ->
    $('.edit_nuggets').css({
      'display': 'block'
      'opacity': 1
    })
    AppContext.grid.prependNuggetToDisplay(AppContext.vizdata.getNuggets())


  $('.add_nugget_section').click( () ->
    Util.log.console 'This is event being called'
    $('.nugget_view').fadeOut(1000)
    $('.add_nugget_control').fadeIn(2000)
    $('#add_nugget_textarea').focus()
  )

  #looking for the escape key 
  $('#add_nugget_textarea').keydown( (evt) ->
    keyCode = if evt.keyCode  then evt.keyCode else evt.which
    # close the edit section if the 'esc' key is hit
    if(keyCode == 27)
      removeAddSection()
    # If user hits 'enter' key, then save the nugget text and remove the add
    # section
    if(keyCode == 13)
      nuggetText = $(this).val()
      console.log($(this).val())
      nugget = {}
      nugget.nuggetId = getNextNuggetId()
      nugget.description = nuggetText
      AppContext.vizdata.addNugget(nugget)
      # Append the nugget to the UI
      AppContext.grid.prependNuggetToDisplay([nugget])
      removeAddSection()
  )

  # Also bind the event to the x on the right hand top
  $('.close_add_nugget').click( () ->
    removeAddSection()
  )

  # prepend the nugget to the UI
  # Parameter: Needs array of nuggets to be added (should be one element array if one element is added.)
  AppContext.grid.prependNuggetToDisplay = (nuggetList) ->
    Util.log.console('Adding the nugget')
    $.each(nuggetList, (idx, nugget) ->
      $('.nugget_desc').prepend("<div class='nugget_listing row'>" + nugget.description + "</div>")
    )

  #remove the add section once the user is finished
  removeAddSection = () ->
    $('#add_nugget_textarea').blur().val('')
    $('.add_nugget_control').fadeOut(1000)
    $('.nugget_view').fadeIn(2000)
  
  # Get the next nugget ID
  getNextNuggetId = () ->
    nextId = 1
    allNuggets = AppContext.vizdata.getNuggets()
    nextId = (AppContext.vizdata.getNuggets().length == 0) ? 1 : AppContext.vizdata.getNuggets().length +1
    Util.log.console('Next Nugget Id ' + nextId)
    return 'N'+nextId
