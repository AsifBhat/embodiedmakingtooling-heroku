$('document').ready(() ->
		options = {
			beforeSend: () -> 
				$('#message').html("")
				$("#percent").html("0%")
				true;
			uploadProgress: () ->
				$("#percent").html(percentComplete+'%')
				true;
			success: () ->
        $("#percent").html('100%')
        $('#message_board').removeClass()
        $('#message_board').addClass("alert alert-success")
        $('#message_board').fadeIn(4000)
        $('#message_board').fadeOut(6000)
        true;
			complete: (response) ->
        $("#message").html("<font color='green'>" + response.responseText + "</font>")
        true;
			error: () ->
        $('#message_board').removeClass()
        $('#message_board').addClass("alert alert-success")
        $('#message_board').fadeIn(4000)
        $('#message_board').fadeOut(6000)
        $("#message").html("<font color='red'> ERROR: unable to upload file</font>")
        true;
		}
		$('#import_file').ajaxForm(options)
		true;
	)