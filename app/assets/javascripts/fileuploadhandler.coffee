jQuery ($) -> -> # Why do we need 5 different ways to do the same think? What about consistency?
    options = {
      beforeSend: () -> 
        $('#message').html("")
      success: () ->
        # Load data sets
        $('#message_board').removeClass()
        $('#message_board').addClass("alert alert-success")
        $('.forces, .solutionComponents, .stories').remove()
        location.reload()
      complete: (response) ->
        $("#message_board").html(response.responseText)
        $('#message_board').fadeIn(4000)
        $('#message_board').fadeOut(6000)
      error: () ->
        $('#message_board').removeClass()
        $('#message_board').addClass("alert alert-important")
        $("#message_board").html("ERROR: Unable to upload file")
    }
    $('#import_file').ajaxForm(options)
