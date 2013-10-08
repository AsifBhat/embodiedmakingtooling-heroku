$('document').ready(() ->
		options = {
			beforeSend: () -> 
				$('#message').html("")
				true;
			uploadProgress: () ->
				true;
			success: () ->
        $('#message_board').removeClass()
        $('#message_board').addClass("alert alert-success")
        $('#message_board').fadeIn(4000)
        $('#message_board').fadeOut(6000)
        $('.forces, .solutionComponents, .stories').remove()
        true;
			complete: (response) ->
        $("#message_board").html("<font color='white'>" + response.responseText + "</font>")
        true;
			error: () ->
        $('#message_board').removeClass()
        $('#message_board').addClass("alert alert-important")
        $("#message_board").html("<font color='white'> ERROR: unable to upload file</font>")
        $('#message_board').fadeIn(4000)
        $('#message_board').fadeOut(6000)
        true;
		}
		$('#import_file').ajaxForm(options)
		true;
	)