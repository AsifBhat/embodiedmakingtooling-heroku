jQuery ($) -> # Why do we need 5 different ways to do the same think? What about consistency?
    #$('#import_button').click ->
    #handleFileSelect(this)

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
    #loadedFiles = evt.target.files # FileList object
    fileText = ''
    fileLines = []
    contentLineExp = /([CFS]\d+)\s+(.+)/i
    splitToken = /\n/

    #FileReader.readAsBinaryString(f);
    fileReader.onloadend =  () ->
      fileText = fileReader.result
      fileLines = fileText.split(splitToken)
      #Util.log.console (fileLines) #(?i)([CSF]\\d+)\\.?\\s+(.+)$ 
      if(AppContext.vizdata.getElements.length > 0)
        AppContext.vizdata.removeAllElements()
      if(AppContext.vizdata.getPositions().length > 0)
        AppContext.vizdata.removeAllPositions()
      
      $.each(fileLines, (idx, line) ->
        Util.log.console('testing..')
        if(contentLineExp.test(line))
          tokens = line.split(/\s+(.+)/)
          Util.log.console(createElementJSON(tokens))
          AppContext.vizdata.addElement(createElementJSON(tokens))
          true
      )
    
  handleFileSelect = (evt) ->
    if(checkForHTML5FileSupport()) 
      Util.log.console "The supporter is good.."
    #console.log('Event was fired')


    #for (i = 0, file; file = files[i]; i++) 
    readFile file for file in evt.target.files
    # Correct regEx: /([CFS]\d+)\s+(.+)/i
    #console.log(fileReader.result);

  document.getElementById('import_file_input').addEventListener('change', handleFileSelect, false)  