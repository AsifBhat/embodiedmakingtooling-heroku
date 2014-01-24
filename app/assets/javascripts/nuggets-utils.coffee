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

  AppContext.grid.addNuggetSection = () ->
    # add the typeahead and a listing mechanism for the nuggets
    $('.edit_nuggets').css({
      'display': 'block'
      'opacity': 1
    })

  $('.add_nugget_section').click( () ->
    Util.log.console 'This is event being called'
    $('.nugget_view').fadeOut(1000)
    $('.add_nugget_control').fadeIn(2000)
    $('#add_nugget_textarea').focus()
  )

  #looking for the escape key 
  $('#add_nugget_textarea').keydown( (evt) ->
    keyCode = if (evt.keyCode) evt.keyCode else evt.which
    if(keyCode == 27)
      removeAddSection()
    if(keyCode == 13)
      console.log($(this).val())
      removeAddSection()
    #do something about saving the same:
    #Event bound to the 'enter' key: more consistent
  )

  #also bind the event to the x on the right hand top
  $('.close_add_nugget').click( () ->
    removeAddSection()
  )

  #remove the add section once the user is finished
  removeAddSection = () ->
    $('#add_nugget_textarea').blur().val('')
    $('.add_nugget_control').fadeOut(1000)
    $('.nugget_view').fadeIn(2000)
  

