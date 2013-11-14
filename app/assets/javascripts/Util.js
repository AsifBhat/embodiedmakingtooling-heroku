var Util = function () {} ;

Util.log = {};

Util.log.console = function(logInfo) {
	if(console) console.log(logInfo);
};