jQuery ($) ->

  checkForHTML5FileSupport = ()->
    if (window.File && window.FileReader && window.FileList && window.Blob) 
      Util.log.console "All the File APIs are supported."
      true
    else 
      Util.log.console "The File APIs are not fully supported in this browser."
      false
  
  createElementJSON = (elemDescArray) ->
    elemJSON = {"elementId" : elemDescArray[0], "description": elemDescArray[1]}

  readFile = (file) ->
    fileReader = new FileReader()
    fileReader.readAsText(file);
    fileText = ''
    fileLines = []
    contentLineExp = /([CFS]\d+)\s+(.+)/i
    splitToken = /\n/

    fileReader.onloadend =  () ->
      fileText = fileReader.result
      fileLines = fileText.split(splitToken)
      if(AppContext.vizdata.getElements().length > 0)
        AppContext.vizdata.removeAllElements()
      if(AppContext.vizdata.getPositions().length > 0)
        AppContext.vizdata.removeAllPositions()
      $.each(fileLines, (idx, line) ->
        if(contentLineExp.test(line))
          tokens = line.split(/\s+(.+)/)
          AppContext.vizdata.addElement(createElementJSON(tokens))
          true
      )
      AppContext.grid.reloadTypeahead()

  handleFileSelect = (evt) ->
    if(checkForHTML5FileSupport()) 
      Util.log.console "HTML5 File API is supported by the browser"
      readFile file for file in evt.target.files
    else 
      Util.log.console ('HTML5 File API is not supported on your browser')

  document.getElementById('import_file_input').addEventListener('change', handleFileSelect, false);