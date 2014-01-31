jQuery ($) ->
	### 
		*** SHOULD EXECUTE POST FILE LOAD ***

		This method fetches the Google UserId for the current user and 
		returns it.  
		Easiest try is to fetch it from the URL once the application is loaded. 
		The Method MUST return a valid userId, else it shall return an empty string.
		In case this method returns an empty string, it must be rejected and an error
		should be reported.
	###
	AppContext.global.getUserId = () ->
		# fetch the Hash from the URL, if not set then return null
		# Need to find alternate way for fetching the Userid, 
		# incase the URL is not set
		appHash = if window.location.hash then window.location.hash else ''
		# Assuming the userId set in the URL for the file is with the string 'userId'
		if(userId != '') then userId = appHash.split('userId=')[1] else ''

	# Method to return timestamps
	AppContext.global.generateTimeStamp = () ->
		Date.now()

	# Method to generateUnique Ids for everyCall
	AppContext.global.generateUniqueId = (userId, timestamp) ->
		if(!userId)
			userId = AppContext.global.getUserId()
		if(!timestamp)
			timestamp = AppContext.global.generateTimeStamp()
		idString = userId + timestamp + Math.ceil(Math.random() * 100000)
		generateSHA1(idString)

	# Generate SHA1 using the 'sha1-v1.5.0.js' : https://github.com/Caligatio/jsSHA
	generateSHA1 = (inputString) ->
		Util.log.console('Generating SHA1 for ')
		Util.log.console inputString
		shaObject = new jsSHA(inputString, 'TEXT')
		shaObject.getHash('SHA-1', 'HEX')
