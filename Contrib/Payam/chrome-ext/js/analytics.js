var log_server = "http://129.78.24.121:8080/chrome-log-ext";

var LogExt_divs = new Array();/** Array: containing all divs produced by this JavaScript
								  * any events triggered on these divs resp. their childNodes
								  * won't be logged */
var FLG_writingLogVal_LogExt = false; // Boolean: flag: if set, writing log entry to logVal_LogExt not possible	

/* timestamp objects */
var startDate_LogExt = new Date();	/* Date: Initialised by LogExt. Load completion timestamp is  
								   calculated relative to this timestamp */
var loadDate_LogExt;			// Date: Initialised on load. All further timestamps are calculated
								// by adding the ms passed since page load completion to this
								//  relative timestamp.

var FLG_LogMousemove_LogExt= false;	// Boolean: while flag set, mousemove logging is interrupted 
								// for all following log attempts
var lastMousePosY_LogExt = 0;		// Integer: last x position of the mouse pointer	
var lastMousePosX_LogExt = 0;		// Integer: last y position of the mouse pointer
								
								
var logVal_LogExt = "";			// String: Initialised when page loads. Contains entire log of actions

//System properties
var logExt_logger_logs_toolbar = false;
var logExt_logger_show_toolbar = false;


window.addEventListener('load', processLoad_LogExt, false);
								  
//document.body.addEventListener('keypress', processMousedown_LogExt, true);
document.body.addEventListener('mousedown', processMousedown_LogExt, true);
document.body.addEventListener('mouseup', processMouseup_LogExt, true);
document.body.addEventListener('mouseover', processMouseover_LogExt, true);
document.body.addEventListener('mouseout', processMouseout_LogExt, true);
//document.body.addEventListener('mousemove', processMousemove_LogExt, true);

loadjscssfile(log_server+"/yui/build/container/assets/skins/sam/container.css","css");
//loadjscssfile(log_server+"/yui/build/reset/reset-min.css","css");
loadjscssfile(log_server+"/yui/build/button/assets/skins/sam/button.css","css");
loadjscssfile(log_server+"/yui/build/progressbar/assets/skins/sam/progressbar.css","css");
loadjscssfile(log_server+"/jquery.jixedbar/themes/default/jx.stylesheet.css","css");
loadjscssfile(log_server+"/jquery-ui/css/ui-lightness/jquery-ui-1.8.13.custom.css","css");
loadjscssfile(log_server+"/css/log_extension.css","css");
loadjscssfile(log_server+"/css/pnotify/jquery.pnotify.default.css","css");

function loadjscssfile(filename, filetype){
	if (filetype=="js"){ //if filename is a external JavaScript file
		var fileref=document.createElement('script')
		fileref.setAttribute("type","text/javascript")
		fileref.setAttribute("src", filename)
	}else if (filetype=="css"){ //if filename is an external CSS file
		var fileref=document.createElement("link")
		fileref.setAttribute("rel", "stylesheet")
		fileref.setAttribute("type", "text/css")
		fileref.setAttribute("href", filename)
	}
	if (typeof fileref!="undefined")
		document.getElementsByTagName("head")[0].appendChild(fileref)
}	

/* Processes load event (logs load event together with the page size) */
function processLoad_LogExt(e) {
//	getDate_LogExt();

	//syncTime_LogExt('firstToken');

	/* get size
	 * NS: first case (window.innerWidth/innerHeight available); IE: second case */
	var loadWidth, loadHeight;
	loadWidth 	= (window.innerWidth) ? window.innerWidth : document.body.offsetWidth;  // innerWidth=NS
	loadHeight 	= (window.innerHeight) ? window.innerHeight : document.body.offsetHeight;  // innerHeight=NS
	writeLog_LogExt("load&page=" + document.URL + "&size=" + loadWidth + "x" + loadHeight);
	//saveLog_LogExt();
	if (top === self) { logExt_init_toolbar(); } else { /*in a frame*/ };
	
}

function processMousemove_LogExt(e) {
	/* get event target, x, and y value of mouse position
	 * NS: first case (window.Event available); IE: second case */
	var ev 		= (window.Event) ? e : window.event;
	var target 	= (window.Event) ? ev.target : ev.srcElement;
	var x 		= (window.Event) ? ev.pageX : ev.clientX;
	var y 		= (window.Event) ? ev.pageY : ev.clientY; 
	
	var xOffset = x - absLeft(target);	// compute x offset relative to the hovered-over element
	var yOffset = y - absTop(target);	// compute y offset relative to the hovered-over element
	
	// if log mousemove flag is false, set it true and log a mousemove event
	if (!FLG_LogMousemove_LogExt
		/** if mouse pointer actually moved */
		&& !(x==lastMousePosX_LogExt && y==lastMousePosY_LogExt) ) {
			FLG_LogMousemove_LogExt = true;
			lastMousePosX_LogExt = x;
			lastMousePosY_LogExt = y;
			
			writeLog_LogExt("mousemove&offset=" + xOffset + "," + yOffset + generateEventString_LogExt(target));
			//saveLog_LogExt();
			window.setTimeout('setInaktiv_LogExt()',150);
	}
}

/* Processes mouseover event
 * logs mouseover events on all elements which have either an
 * id, name, href, or src property (logging more would cause a log overload) */ 
function processMouseover_LogExt(e) {
	
	/* get event target
	 * NS: first case (window.Event available); IE: second case */
	var ev = (window.Event) ? e : window.event;
	var target = (window.Event) ? ev.target : ev.srcElement;
	
	/** check if element wasn't created by this JavaScript
	  * by examining if element or the element's parent is contained in the LogExt_divs array */
	if(logExt_checkWhetherNeedsToBelogged(target)) {
		
		// log mouseover coordinates and all available target attributes
		// if element has an id attribute
		/** only links, images, and form elements*/
		if (target.type=="select-one" 
			 || target.type=="select-multiple" 
			 || target.type=="textarea" 
			 || target.nodeName=="input" 
			 || target.nodeName=="INPUT"
			 || target.href
			 || target.src) {
			if (target.id) { 
				writeLog_LogExt("mouseover&id=" + target.id
									+ generateEventString_LogExt(target));
				//saveLog_LogExt();
			}
			else {
				// if element has a name attribute
				if(target.name) {
					writeLog_LogExt("mouseover&name=" + target.name
										+ generateEventString_LogExt(target));
					//saveLog_LogExt();
				} else {
					// if element has an href or src attribute
					if (target.href || target.src) {
						writeLog_LogExt("mouseover" + generateEventString_LogExt(target));
						//saveLog_LogExt();
					}
				}
			}
		}
	}
}

function logExt_checkWhetherNeedsToBelogged(target){
	if (logExt_logger_logs_toolbar){
		return true;
	}else{	
		return !(( target.id && containsArrayEntry_LogExt(LogExt_divs, target.id) )	|| ( target.parentNode.id && containsArrayEntry_LogExt(LogExt_divs, target.parentNode.id) )	)
	}
}

/* Processes mouseout event
 * logs mouseout events on all elements which have either an
 * id, name, href, or src property (logging more would cause a log overload) */ 
function processMouseout_LogExt(e) {
	
	/* get event target
	 * NS: first case (window.Event available); IE: second case */
	var ev = (window.Event) ? e : window.event;
	var target = (window.Event) ? ev.target : ev.srcElement; 
	
	/** check if element wasn't created by this JavaScript
	  * by examining if element or the element's parent is contained in the LogExt_divs array */
	if(logExt_checkWhetherNeedsToBelogged(target)) {
		
		// log mouseout coordinates and all available target properties
		// if element has an id attribute
		/** only links, images, and form elements*/
		if (target.type=="select-one" 
			 || target.type=="select-multiple" 
			 || target.type=="textarea" 
			 || target.nodeName=="input" 
			 || target.nodeName=="INPUT"
			 || target.href
			 || target.src) {
			if (target.id) { 
				writeLog_LogExt("mouseout&id=" + target.id
									+ generateEventString_LogExt(target));
				//saveLog_LogExt();
			}
			else {
				// if element has a name attribute
				if(target.name) {
					writeLog_LogExt("mouseout&name=" + target.name
										+ generateEventString_LogExt(target));
					//saveLog_LogExt();
				} else {
					// if element has an href or src attribute
					if (target.href || target.src) {
						writeLog_LogExt("mouseout" + generateEventString_LogExt(target));
						//saveLog_LogExt();
					}
				}
			}
		}
	}
}

/* Resets the log mousemove blocking flag so that the next 
   mousemove event may be logged */
function setInaktiv_LogExt() {
	FLG_LogMousemove_LogExt = false;
}

function processMousedown_LogExt(e) {

	/* get event target, x, and y value of mouse position
	 * NS: first case (window.Event available); IE: second case */
	var ev 		= (window.Event) ? e : window.event;
	var target 	= (window.Event) ? ev.target : ev.srcElement;
	var x 		= (window.Event) ? ev.pageX : ev.clientX;
	var y 		= (window.Event) ? ev.pageY : ev.clientY; 
	
	var xOffset = x - absLeft(target);	// compute x offset relative to the hovered-over element
	var yOffset = y - absTop(target);	// compute y offset relative to the hovered-over element
	
	/** check if element wasn't created by this JavaScript
	  * by examining if element or the element's parent is contained in the LogExt_divs array */
	if(logExt_checkWhetherNeedsToBelogged(target)) {
		
		/** mouse button detection: was middle or right mouse button clicked ? */
		var mbutton = "left";
		if (ev.which) {  		// NS
			switch(ev.which) {
				case 2: mbutton = "m"; break;	// middle button
				case 3: mbutton = "r"; break;	// right button
			}
		} else if (ev.button) {		// IE
			switch(ev.button) {
				case 4: mbutton = "m"; break;
				case 2: mbutton = "r"; break;
			}
		}
		
		/** if left mouse button was pressed and the target element
		    isn't a direct child node of
		    the top-level HTML element e.g. the scrollbar */
		if (mbutton=="left" && target.parentNode!=document.documentElement) {
			
			/* if regular click, log click coordinates relative to the clicked element
	   		   and all available target attributes */
			// if element has an id attribute
			if (target.id) 	writeLog_LogExt("mousedown&offset=" + xOffset + "," + yOffset + "&id=" + target.id + generateEventString_LogExt(target) );
			else {
				// if element has a name attribute
				if(target.name) writeLog_LogExt("mousedown&offset=" + xOffset + "," + yOffset + "&name=" + target.name + generateEventString_LogExt(target));
				else {
					writeLog_LogExt("mousedown&offset=" + xOffset + "," + yOffset + generateEventString_LogExt(target));
				}
			}
			
		}
	}
}

/* similar to mousedown */
function processMouseup_LogExt(e) {

	/* get event target, x, and y value of mouse position
	 * NS: first case (window.Event available); IE: second case */
	var ev 		= (window.Event) ? e : window.event;
	var target 	= (window.Event) ? ev.target : ev.srcElement;
	var x 		= (window.Event) ? ev.pageX : ev.clientX;
	var y 		= (window.Event) ? ev.pageY : ev.clientY; 
	
	var xOffset = x - absLeft(target);	// compute x offset relative to the hovered-over element
	var yOffset = y - absTop(target);	// compute y offset relative to the hovered-over element
	
	/** check if element wasn't created by this JavaScript
	  * by examining if element or the element's parent is contained in the LogExt_divs array */
	if(!(
		( target.id && containsArrayEntry_LogExt(LogExt_divs, target.id) )
		|| ( target.parentNode.id && containsArrayEntry_LogExt(LogExt_divs, target.parentNode.id) )
		)) {
		
		/** mouse button detection: was middle or right mouse button clicked ?*/
		var mbutton = "left";
		if (ev.which) {  		// NS
			switch(ev.which) {
				case 2: mbutton = "m"; break;	// middle button
				case 3: mbutton = "r"; break;	// right button
			}
		} else if (ev.button) {		// IE
			switch(ev.button) {
				case 4: mbutton = "m"; break;
				case 2: mbutton = "r"; break;
			}
		}
	
		/** if left mouse button was pressed and the target element
		    isn't a direct child node of
		    the top-level HTML element e.g. the scrollbar */
		if (mbutton=="left" && target.parentNode!=document.documentElement) {
			
			// if regular click log click coordinates and all available target attributes
			// if element has an id attribute
			if (target.id) 	writeLog_LogExt("mouseup&offset=" + xOffset + "," + yOffset + "&id=" + target.id + generateEventString_LogExt(target) );
			else {
				// if element has a name attribute
				if(target.name) writeLog_LogExt("mouseup&offset=" + xOffset + "," + yOffset + "&name=" + target.name + generateEventString_LogExt(target));
				else {
					writeLog_LogExt("mouseup&offset=" + xOffset + "," + yOffset + generateEventString_LogExt(target));
				}
			}
			
		}
	}
}

function datestamp_LogExt() {

	return (new Date()).getTime();

	if (loadDate_LogExt==null) loadDate_LogExt = new Date();
	var currentDate 	= new Date();
	// get milliseconds from loading time
	var diffSecs 		= Math.abs(currentDate.getTime() - loadDate_LogExt.getTime());
	// return new Date object according to LogExt start time + diffMSecs
	var currentUPDate 	= new Date(startDate_LogExt.getTime() + diffSecs);
	//alert(currentUPDate);
	return currentUPDate.getFullYear() + "-" + completeDateVals(currentUPDate.getMonth()) + "-"
	  + completeDateVals(currentUPDate.getDate()) + "," + completeDateVals(currentUPDate.getHours())
	  + ":" + completeDateVals(currentUPDate.getMinutes())
	  + ":" + completeDateVals(currentUPDate.getSeconds());
}


function writeLog_LogExt(text /*string*/) {

	/*TODO: This must be handle in much better way*/
	if ((text.indexOf("&id=emotion_rating_check") > -1 || text.indexOf("&id=emotion_rating_background") > -1) && text.indexOf("va_ratings") == -1){
		return;
	}

	if(FLG_writingLogVal_LogExt) { window.setTimeout("writeLog_LogExt('" + text + "')",50); return;}
	var logline;
	
	// generate and append log entry
	logLine = "timeStamp=" + datestamp_LogExt() + "&event=" + text;
	
	// set synchronization flag (block function)
	FLG_writingLogVal_LogExt = true;
	logVal_LogExt = logVal_LogExt + logLine + "&xX"; // add logLine to interaction log
	/* send captured data to the proxy;
	   to reduce the amount of requests this command may be hidden */
	saveLog_LogExt();
	// reset synchronization flag (release function)
	FLG_writingLogVal_LogExt = false;
}



/** Sends tracked usage data (if available) to LogExt */
function saveLog_LogExt() {
	if(logVal_LogExt!="") {
		chrome.extension.sendRequest({cmd: "log",url: log_server+"/log.do?command=logData&" +logVal_LogExt} , handleSendLog_LogExt);
		//xmlreqGET_LogExt("http://129.78.24.121:8080/chrome-log-ext/log.jsp?" + logVal_LogExt, "handleSendLog_LogExt");
		logVal_LogExt = ""; // reset log data
	}
}

function getDate_LogExt() {
	FLG_writingLogVal_LogExt = true;
	chrome.extension.sendRequest({cmd: "log",url: log_server+"/log.do?command=getServerTime"} , handleSetDate_LogExt);
}


function handleSetDate_LogExt(responseText){
	var data = JSON.parse(responseText);
	
	startDate_LogExt = new Date(parseInt(data.time));
	FLG_writingLogVal_LogExt = false;
}

function syncTime_LogExt(token) {
	chrome.extension.sendRequest({cmd: "log",url: log_server+"/log.do?command=SyncTime&token="+token} , handleSyncTime_LogExt);
}

function handleSyncTime_LogExt(responseText){
	var data = JSON.parse(responseText);
	if (data.reply == "true"){
		syncTime_LogExt(data.token);
	}
}

function handleSendLog_LogExt(responseText){
	var data = JSON.parse(responseText);
	//alert(data.recieved);
}

/* Returns true if the specified array contains the value. */
function containsArrayEntry_LogExt(array /*Array*/, value /*string*/){
    var exists = false;
    for (var i in array) {
        if (array[i] == value && array[i] != null) {
            exists = true;
            break;
        }
    }
    return exists;
}

/** Completes single-digit numbers by a "0"-prefix */
function completeDateVals(dateVal /*string*/) {
	var dateVal = "" + dateVal;
	if (dateVal.length<2) return "0" + dateVal;
	else return dateVal;
}


/* Computes the element's offset from the left edge
   of the browser window */
function absLeft(element) {
	if (element.pageX) return element.pageX;
	else
    	return (element.offsetParent)? 
     	element.offsetLeft + absLeft(element.offsetParent) : element.offsetLeft;
  }

/* Computes the element's offset from the top edge
   of the browser window */
function absTop(element) {
  	if (element.pageY) return element.pageY;
	else
     	return (element.offsetParent)? 
     	element.offsetTop + absTop(element.offsetParent) : element.offsetTop;
}

/* Returns the DOM path of the specified DOM node beginning with the first
 * corresponding child node of the document node (i.e. HTML) */
function getDOMPath(node /*DOM element*/) {
	if(node.parentNode.nodeType==9) return getDOMIndex(node);
	else return getDOMPath(node.parentNode) + getDOMIndex(node);
}
/** Returns the position of the specified node 
    in its parent node's childNodes array */
function getDOMIndex(node /*DOM element*/) {
	var parent = node.parentNode;
	var children = parent.childNodes;
	var length = children.length;
	var position = 0;
	for (var i = 0; i < length; i++) {
		if (children[i].nodeType==1) { // count only element nodes
			position += 1;
			if (children[i] == node) {
				return mapToAlph(position);
			}
		} 
	}
}

/* Returns an alphabetic representation of the DOM path
 * e.g. having a path of <HTML><BODY><FORM><P>1st<INPUT>
 * results in bbaaa
 * e.g. having a path of <HTML><BODY><FORM><P>34th<INPUT>
 * results in bbaa1h
 * with an optional number as prefix which indicates the extent
 * to which the position exceeds the number of characters available
 * e.g. a position of 54 is represented by 2b (= 2x26 + b)*/
var alphArray = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
function mapToAlph(position) {
	var amountAlphs = 0;
	var alphRemain = "";
	if(position>alphArray.length) { // if position > available indexes
		amountAlphs = Math.floor(position/alphArray.length);
		alphRemain = alphArray[(position % alphArray.length)-1];
	} 
	if(amountAlphs>0) return (amountAlphs + alphRemain);
	return (alphArray[position-1]);
}

function generateEventString_LogExt(node /*DOM element*/) {
	var eventString = "";
	eventString = eventString + "&dom=" + getDOMPath(node);  // append DOM path
	
	// if target has a href property
	if (node.href) {
		/* image detection IE: IE doesn't register any src property
		 * instead href contains the file path */
		if(node.nodeName=="img" || node.nodeName=="IMG") {	
			// if linked image (parent node is an <a>-element)
			if(node.parentNode.href)  
				eventString = eventString + "&img=" + getFileName(node.href) + "&link=" + node.parentNode.href;
			else eventString = eventString + "&img=" + getFileName(node.href);
		}
		// NS+IE: link detection
		else if(node.nodeName=="a" || node.nodeName=="A") {  // if anchor tag
			// IE: innertext property contains link text
			if (node.innerText)
				eventString = eventString + "&link=" + node.href + "&text=" + escape(node.innerText);
			// NS: text property contains link text
			else eventString = eventString + "&link=" + node.href + "&text=" + escape(node.text);
		}
	} else {
		// image detection NS
		if (node.src) {		
			if (node.parentNode.href)
				eventString = eventString + "&img=" + getFileName(node.src) + "&link=" + node.parentNode.href
			else eventString = eventString + "&img=" + getFileName(node.src);
		}
	}
	
	return eventString;
}

/* Returns file name of a URL/path */
function getFileName(path /*string*/) {
	if(path.lastIndexOf("/")>-1)
		return path.substring(path.lastIndexOf("/")+1);
	else return path;
}

/*Ratings code*/

var log_ext_sec = 0;
var log_ext_stopTimer = true;
var log_ext_next_timer_event = (new Date()).getTime();
var log_ext_rating_time_based = false;

function log_ext_UpRepeat() {
	if (log_ext_stopTimer)
	{
		return;
	}
	
	if ((new Date()).getTime() >= log_ext_next_timer_event){
		sendSystemEventToServer_LogExt("TIMER","-1","");
		return;
	}
	
	log_ext_sec = log_ext_sec + 1;
	
	if (log_ext_sec > YAHOO.log.extension.progressBar.get('maxValue')){
		YAHOO.log.extension.progressBar.set('value', YAHOO.log.extension.progressBar.get('maxValue'));
		sendSystemEventToServer_LogExt("TIMER","-1","");
		return;
	}else{
		YAHOO.log.extension.progressBar.set('value',log_ext_sec);
		up=setTimeout("log_ext_UpRepeat()",1000);
	}
	
	
}

function sendDataToServer_LogExt(command, taskId, handleFunction){
	chrome.extension.sendRequest({cmd: "log",url: log_server+"/log.do?command="+command+"&taskId="+taskId+"&timeStamp=" + datestamp_LogExt()},  handleFunction);
}

function sendSystemEventToServer_LogExt(systemEventType,systemEventId,selectedIds){
	log_ext_stopTimer = true;
	taskId = $("#log_ext_jixedbar_currentTaskID").val();
	chrome.extension.sendRequest({cmd: "log",url: log_server+"/log.do?command=systemEvent&systemEventType="+systemEventType+"&systemEventId="+systemEventId+"&taskId="+taskId+"&selectedIds="+selectedIds+"&timeStamp=" + datestamp_LogExt()},  function (responseText){logExt_process_current_session(responseText);});
}

function logExt_process_current_session (responseText){
	resetAllQuestionnaires();
	var data = JSON.parse(responseText);
	
	log_ext_next_timer_event = data.nextTimerEvent;
	if (data.questionnair != "null"){
		var questionnair = JSON.parse(data.questionnair);
		var systemEvent = null;
		if (data.systemEvent != "null"){
			systemEvent =  JSON.parse(data.systemEvent);
		}
		logExt_start_rating(questionnair,systemEvent);
	}else{
		var task = JSON.parse(data.task);
		manageTask_BottomBar(task);
		if (data.isMildEventInterruption == "true"){
			logExt_show_mild_notification();
		}
	}
	
}



function manageTask_BottomBar(task){
	resetAllGlobalRatingsVariables_LogExt();
	
	for(i =1;i<19;i++){
		$('#log_ext_jixedbar_currentTask_option'+i).html("");
	}
	
	if (task.type == 1){
		$("#log_ext_jixedbar_currentTask").html("<b>Current Task:</b> No More Tasks.");
		$("#log_ext_jixedbar_currentTask").attr("title","");
		$("#log_ext_jixedbar_currentTaskDone").hide();
		$("#log_ext_jixedbar_progressbar").hide();
	}else{
	
		var taskParams = task.taskParams;
		currentTaskTitle = task.title;
		$("#log_ext_jixedbar_currentTask").html("<b>Current Task:</b> "+currentTaskTitle);
		$("#log_ext_jixedbar_currentTask").attr("title",currentTaskTitle);
		
		
		$("#log_ext_jixedbar_currentTaskID").val(task.id);
		$("#log_ext_jixedbar_currentTaskDone").show();
		$("#log_ext_jixedbar_progressbar").show();
		
		j = 1;
		jQuery.each(taskParams, function(name, value) {
			j++;
		});
		jQuery.each(taskParams, function(name, value) {
			$('#log_ext_jixedbar_currentTask_option'+j).html("<a><b>"+name+"</b>: "+value+"</a>");
			j--;
		});
		
		YAHOO.log.extension.progressBar.set('anim',false); 
		sendDataToServer_LogExt("getTaskElapsedTime",task.id,function (responseText){
			var data = JSON.parse(responseText);
			
			
			taskElapsedTime = data.taskElapsedTime;
			YAHOO.log.extension.progressBar.set('minValue',0); 
			YAHOO.log.extension.progressBar.set('maxValue',Math.round(task.maxAllowedTime));
			YAHOO.log.extension.progressBar.set('value',Math.round(taskElapsedTime/1000));
			log_ext_sec = Math.round(taskElapsedTime/1000);
			log_ext_stopTimer = false;
			setTimeout(function(){
				YAHOO.log.extension.progressBar.set('anim',true);
				var anim = YAHOO.log.extension.progressBar.get('anim');
				anim.duration = 1;
				anim.method = YAHOO.util.Easing.easeNone;
				},100);
			log_ext_UpRepeat();
		});
	}
	
}


chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
    sendDataToServer_LogExt("getCurrentSession","0", function (responseText){
		logExt_process_current_session(responseText);
	});
	if (request.cmd == "tabChanged" ){
		writeLog_LogExt("tabChanged&page=" + document.URL );
	}else if (request.cmd == "tabCreated"){
		writeLog_LogExt("tabCreated&page=" + document.URL );
	}else if (request.cmd == "tabUpdated"){
		writeLog_LogExt("tabUpdated&page=" + document.URL );
	}else if (request.cmd == "tabRemoved"){
		writeLog_LogExt("tabRemoved&page=" + document.URL );
	}
});

function logExt_init_toolbar(){
	sendDataToServer_LogExt("getSystemProperties","0", function (responseText){
		var data = JSON.parse(responseText);
		var systemProperties = JSON.parse(data.systemProperties);
	
		logExt_logger_logs_toolbar = systemProperties.logToolbar;
		logExt_logger_show_toolbar = systemProperties.showToolbar;

		renderAllQuestionnaies();
		
		logExt_render_toolbar(logExt_logger_show_toolbar);
		

	});
}

function logExt_render_toolbar(show_toolbar){

	YAHOO.namespace("log.extension");
	$('body').addClass( "yui-skin-sam" );

	chrome.extension.sendRequest({cmd: "read_file",url: "bottombar.html"}, function(html){
		$('body').prepend(html);
		for(i =1;i<19;i++){
			$("#log_ext_jixedbar_currentTask_options").prepend("<li id='log_ext_jixedbar_currentTask_option"+i+"'></li>");
			if(!containsArrayEntry_LogExt(LogExt_divs, "log_ext_jixedbar_currentTask_option"+i))
				LogExt_divs.push("log_ext_jixedbar_currentTask_option"+i);
		}
		
		$("div#log_ext_jixedbar").jixedbar({
			showOnTop: true,
			transparent: true,
			opacity: 0.7,
			slideSpeed: "slow",
			roundedCorners: false,
			roundedButtons: false,
			menuFadeSpeed: "slow",
			tooltipFadeSpeed: "fast",
			tooltipFadeOpacity: 0.7
		});

		if (!show_toolbar){
			$("div#log_ext_jixedbar").hide();
		}
		
		if(!containsArrayEntry_LogExt(LogExt_divs, "log_ext_jixedbar"))
			LogExt_divs.push("log_ext_jixedbar");
		if(!containsArrayEntry_LogExt(LogExt_divs, "log_ext_jixedbar_currentTask"))
			LogExt_divs.push("log_ext_jixedbar_currentTask");
		if(!containsArrayEntry_LogExt(LogExt_divs, "log_ext_jixedbar_progressbar"))
			LogExt_divs.push("log_ext_jixedbar_progressbar");			
		
		
		sendDataToServer_LogExt("getCurrentSession","0", function (responseText){
			logExt_process_current_session(responseText);
		});
		
		
		$("#log_ext_jixedbar_reset").click(function() {
			var answer = confirm("Are you sure you want to reset the plugin?")
			if (answer){
				sendSystemEventToServer_LogExt("RESET","-1","");
			}
		});
		if(!containsArrayEntry_LogExt(LogExt_divs, "log_ext_jixedbar_reset"))
			LogExt_divs.push("log_ext_jixedbar_reset");
			
		var imgURL = chrome.extension.getURL("check.png");
		$("#log_ext_jixedbar_currentTaskDone").html("<img src='"+imgURL+"' height='20px' title='Flag this task as done' /><span style='height:20px;vertical-align:top'>Task Done</span>");
		$("#log_ext_jixedbar_currentTaskDone").click(function() {
			var answer = confirm("Are you sure you want to set this task as done?")
			if (answer){
				
				sendSystemEventToServer_LogExt("setCurrentTaskDone","-1","");
			}
		});
		if(!containsArrayEntry_LogExt(LogExt_divs, "log_ext_jixedbar_currentTaskDone"))
			LogExt_divs.push("log_ext_jixedbar_currentTaskDone");
			
		imgURL = chrome.extension.getURL("start.png");
		$("#log_ext_jixedbar_webcamstart").html("<img src='"+imgURL+"' height='20px' title='Start Webcam' />");
		$("#log_ext_jixedbar_webcamstart").click(function() {
			 window.location = "cam:\\option[start]dir[c:\\hamed_video\\]";
			
		});	
		if(!containsArrayEntry_LogExt(LogExt_divs, "log_ext_jixedbar_webcamstart"))
			LogExt_divs.push("log_ext_jixedbar_webcamstart");
		
		imgURL = chrome.extension.getURL("stop.png");
		$("#log_ext_jixedbar_webcamstop").html("<img src='"+imgURL+"' height='20px' title='Stop Webcam' />");
		$("#log_ext_jixedbar_webcamstop").click(function() {
			 window.location = "cam:\\option[stop]dir[c:\\hamed_video\\]";
			
		});			
		if(!containsArrayEntry_LogExt(LogExt_divs, "log_ext_jixedbar_webcamstop"))
			LogExt_divs.push("log_ext_jixedbar_webcamstop");				
			
			
		YAHOO.log.extension.progressBar = new YAHOO.widget.ProgressBar({value: 0,anim: false}).render("log_ext_jixedbar_progressbar");
		if(!containsArrayEntry_LogExt(LogExt_divs, "log_ext_jixedbar_progressbar"))
			LogExt_divs.push("log_ext_jixedbar_progressbar");
		//var anim = YAHOO.log.extension.progressBar.get('anim');
		//anim.duration = 1;
		//anim.method = YAHOO.util.Easing.easeNone;
	});
}



var logExtCurrentSystemNotify = null;

function logExt_show_mild_notification(){
	if (logExtCurrentSystemNotify == null){
		$.pnotify.defaults.pnotify_history = false;
		logExtCurrentSystemNotify = $.pnotify({
			pnotify_title: 'Questionnair Notice',
			pnotify_text: 'Questionnair ready for you to answer. Click me!',
			pnotify_hide: false,
			pnotify_closer: false,
			pnotify_animation: function(status, callback, pnotify){
				pnotify.toggle();
				logExt_Blink_animation_Pnotify(pnotify);
				pnotify.container.css( 'cursor', 'pointer' );
				pnotify.container.click(function (){
					pnotify.hide();
					sendSystemEventToServer_LogExt("mildNotificationClicked","-1","");
				});
				// Always call the callback.
				callback();
			}
		});
	}
	logExtCurrentSystemNotify.show();
	
}

var logExtCurrentSystemEvent = null;
function logExt_start_rating(questionnaire,systemEvent){
	if (logExtCurrentSystemNotify != null){
		logExtCurrentSystemNotify.hide();
	}
	log_ext_stopTimer = true;
	logExtCurrentSystemEvent = systemEvent;
	var ques_id = "rating_dialog_"+questionnaire.id;
	$('#'+ques_id).dialog('open');
	
}

var logExt_Blink_animation_Pnotify_flag = false;
function logExt_Blink_animation_Pnotify(pnotify) { 
	if(logExt_Blink_animation_Pnotify_flag){
		pnotify.title_container.fadeIn(1500);
	}else{
		pnotify.title_container.fadeOut(1500);
	}
	logExt_Blink_animation_Pnotify_flag = !logExt_Blink_animation_Pnotify_flag;
	setTimeout(function(){
		logExt_Blink_animation_Pnotify(pnotify)
	}, 1000);
}


var ratings_low_opt = 0.1;
var ratings_high_opt = 1;
var logExt_ratings_selected = new Array();
var logExt_ratings_selected_obj = new Array();

function logExt_rating_CheckOne_onMouseOver(obj){
	obj.style.opacity=ratings_high_opt;
	if (obj.filters){
		obj.filters.alpha.opacity=ratings_high_opt*100
	}
	return false;
}
function logExt_rating_CheckOne_onMouseOut(obj){
	if (!logExt_ratings_selected[obj.id] || logExt_ratings_selected_obj[obj.id] != obj){
		obj.style.opacity=ratings_low_opt;
		if (obj.filters){
			obj.filters.alpha.opacity=ratings_low_opt*100;
		}
	}
	
	return false;	
}
function logExt_rating_CheckOne_onMouseClick(obj){
	var otherCheckObjs = obj.otherCheckObjs;
	for (i=1;i<otherCheckObjs.length ;i++ ){	
		var tmp_obj = document.getElementById(otherCheckObjs[i]);
		logExt_ratings_selected[tmp_obj.id] = false;
		logExt_ratings_selected_obj[tmp_obj.id] = null;
		tmp_obj.style.opacity=ratings_low_opt;
		if (tmp_obj.filters){
		 	 tmp_obj.filters.alpha.opacity=ratings_low_opt*100;
		}
	}	
	obj.style.opacity=ratings_high_opt;
	if (obj.filters){
		obj.filters.alpha.opacity=ratings_high_opt*100;
	}
	logExt_ratings_selected[obj.id] = true;
	logExt_ratings_selected_obj[obj.id] = obj;
	
	return false;
}




function resetAllGlobalRatingsVariables_LogExt(){
	log_ext_sec = 0;
	log_ext_stopTimer = true;
	log_ext_rating_time_based = false;
	logExt_ratings_selected = new Array();
	logExt_ratings_selected_obj = new Array();
}

function resetAllQuestionnaires(){
	for(i=0;i<allQuestionnaiesId.length;i++){
		var ques_id = "rating_dialog_"+allQuestionnaiesId[i];
		allQuestionnaiesResetFunctions[allQuestionnaiesId[i]]();
		$('#'+ques_id).dialog('close');
	}
}

var allQuestionnaiesId = new Array();
var allQuestionnaiesResetFunctions = new Array();
var renderAllQuestionnaies_alreadyCalled = false;
function renderAllQuestionnaies(){
	if (renderAllQuestionnaies_alreadyCalled){
		return;
	}
	renderAllQuestionnaies_alreadyCalled = true;
	
	sendDataToServer_LogExt("getAllQuestionnaire","0", function (responseText){
			var data = JSON.parse(responseText);
			var questionnaires = JSON.parse(data.questionnaires);
			var	k = 0;
			jQuery.each(questionnaires, function(name, questionnaire) {
				var ques_id = "rating_dialog_"+questionnaire.id;
				
				$('body').prepend('<div id='+ques_id+ ' title="'+questionnaire.title+'" ></div>');
				$('#'+ques_id).data('questionnaireId', questionnaire.id);				
		
				if(!containsArrayEntry_LogExt(LogExt_divs, ques_id))
						LogExt_divs.push(ques_id);
				
				var validateFunction = new Array();
				
				
				if (questionnaire.rating.type == "SAM"){
					var allCheckObj = new Array();
					
					var HTMLDialogBody = "";
					var top = 52;
					var left = 30;
					var i = 1;
					jQuery.each(questionnaire.questions, function(name, question) {
						var imgURL = "";
						allCheckObj[i] = new Array();
						if (question.title == "Valence"){
							imgURL = chrome.extension.getURL("SAM/SAM-V-9.png");
						}else if (question.title == "Arousal"){
							imgURL = chrome.extension.getURL("SAM/SAM-A-9.png");
						}else if (question.title == "Dominance"){
							imgURL = chrome.extension.getURL("SAM/SAM-D-9.png");
						}
						HTMLDialogBody += "<p><img width='650px' id='logExt_"+ques_id+"_"+question.id+"' border='0' src='"+imgURL+"'/></p>";
						if(!containsArrayEntry_LogExt(LogExt_divs, "logExt_"+ques_id+"_"+question.id))
								LogExt_divs.push("logExt_"+ques_id+"_"+question.id);
						
						var imgURL = chrome.extension.getURL("checkone/check.png");
						for (j=1;j<=9 ;j++ ){
							HTMLDialogBody += "<img id='logExt_"+ques_id+"_"+question.id+"_"+j+"' style='Z-INDEX: 100; POSITION: absolute; FILTER: alpha(opacity=10); TOP: "+top+"px; LEFT: "+left+"px'  border='0' src='"+imgURL+"' width='60' height='40'/>";
							if(!containsArrayEntry_LogExt(LogExt_divs, "logExt_"+ques_id+"_"+question.id+"_"+j))
								LogExt_divs.push("logExt_"+ques_id+"_"+question.id+"_"+j);
							left += 71;
							allCheckObj[i][j] = "logExt_"+ques_id+"_"+question.id+"_"+j;
						}
						left = 30;
						top += 110;
						i++;
					});
					if (questionnaire.showComment){
						HTMLDialogBody += "Comments: <textarea style='width:400px' id='resizable' ></textarea> ";
					}
					$('#'+ques_id).prepend(HTMLDialogBody); 
					
					for (i=1;i<allCheckObj.length;i++){
						for (j=1;j<allCheckObj[i].length;j++){
							var obj = document.getElementById(allCheckObj[i][j]);
							obj.otherCheckObjs = allCheckObj[i];
							obj.addEventListener('mouseover',  function(e) {logExt_rating_CheckOne_onMouseOver(e.target);}, true);
							obj.addEventListener('mouseout', function(e) {logExt_rating_CheckOne_onMouseOut(e.target);}, true);
							obj.addEventListener('click', function(e) {logExt_rating_CheckOne_onMouseClick(e.target);}, true);
							obj.style.opacity=ratings_low_opt;
							if (obj.filters)
							{
								obj.filters.alpha.opacity=ratings_low_opt*100;
							}
						}
					}
					
					validateFunction[questionnaire.id] = function() {
						var rowSelectedObj = new Array();
						var rowSelected = new Array();
						for (i=1;i<allCheckObj.length;i++){
							rowSelected[i] = false;
							rowSelectedObj[i] = null;
							for (j=1;j<allCheckObj[i].length;j++){
								if (logExt_ratings_selected[allCheckObj[i][j]]){
									rowSelected[i] = true;
									rowSelectedObj[i] = logExt_ratings_selected_obj[allCheckObj[i][j]];
									break;
								}	
								
							}
						}
						var msg = "Please select one option for row(s):"
						var hasError = false;
						var selectedIds = "";
						var first = true;
						for (i=1;i<rowSelected.length;i++){
							if (!rowSelected[i]){
								if (hasError){
									msg += ",";
								}
								msg += " "+i;
								hasError = true;
							}else{
								if (!first) selectedIds += "-";
								selectedIds += rowSelectedObj[i].id;
								first = false;
							}
						}
						if (hasError){
							alert(msg);
							return false;
						}else{
							sendSystemEventToServer_LogExt("RATING_ENDED",logExtCurrentSystemEvent.id,selectedIds);
							return true;
						}
					};
					
					allQuestionnaiesResetFunctions[questionnaire.id] = function(){
						for (i=1;i<allCheckObj.length;i++){
							for (j=1;j<allCheckObj[i].length;j++){
								var obj = document.getElementById(allCheckObj[i][j]);
								obj.style.opacity=ratings_low_opt;
								if (obj.filters)
								{
									obj.filters.alpha.opacity=ratings_low_opt*100;
								}
								logExt_ratings_selected[allCheckObj[i][j]] = false;
								logExt_ratings_selected_obj[allCheckObj[i][j]] = null;
							}
						}
					}
					
					
				}else if (questionnaire.rating.type == "CheckOne"){
				
					var HTMLDialogBody = "";
					var top = 60;
					var left = 50;
					var i = 1;
					var allCheckObj = new Array();
					var rowNo = 1;
					jQuery.each(questionnaire.questions, function(name, question) {
						HTMLDialogBody += "<div style='Z-INDEX: 60; POSITION: absolute; WIDTH: 140px; HEIGHT: 60px; TOP: "+top+"px; LEFT: "+left+"px'>  <font size='5'>"+question.title+" </font></div>";
						
						var imgURL = chrome.extension.getURL("checkone/check.png");
						HTMLDialogBody += "<img id='logExt_"+ques_id+"_"+question.id+"' style='Z-INDEX: 100; POSITION: absolute; FILTER: alpha(opacity=10); TOP: "+(top - 10)+"px; LEFT: "+(left+25)+"px'  border='0' src='"+imgURL+"' width='60' height='40'/>";
						if(!containsArrayEntry_LogExt( "logExt_"+ques_id+"_"+question.id))
								LogExt_divs.push( "logExt_"+ques_id+"_"+question.id);
						allCheckObj[i] = "logExt_"+ques_id+"_"+question.id;
						if ( (i % 3) == 0){
							left = 50;
							top += 70;
							rowNo++;
						}else{
							left += 200;
						}
						i++;
					});
					if ((i % 3) == 1) rowNo--;
					var width =  140 * 3 + 200;
					var height =  rowNo * 70 + 50; 
					
					HTMLDialogBody += "<div style='width:"+width+"px;height:"+height+"px'></div>";
					
					if (questionnaire.showComment){
						HTMLDialogBody += "Comments: <textarea id='ssssssss' ></textarea> ";
					}
					
					
					$('#'+ques_id).prepend(HTMLDialogBody); 
					
					for (i=1;i<allCheckObj.length;i++){
						var obj = document.getElementById(allCheckObj[i]);
						obj.otherCheckObjs = allCheckObj;
						obj.addEventListener('mouseover',  function(e) {logExt_rating_CheckOne_onMouseOver(e.target);}, true);
						obj.addEventListener('mouseout', function(e) {logExt_rating_CheckOne_onMouseOut(e.target);}, true);
						obj.addEventListener('click', function(e) {logExt_rating_CheckOne_onMouseClick(e.target);}, true);
						obj.style.opacity=ratings_low_opt;
						if (obj.filters){
							obj.filters.alpha.opacity=ratings_low_opt*100;
						}
					}
					
					validateFunction[questionnaire.id] = function() {
						var selectedObj = null;
						var isSelected = false;
						for (i=1;i<allCheckObj.length;i++){
							if (logExt_ratings_selected[allCheckObj[i]]){
									isSelected = true;
									selectedObj = logExt_ratings_selected_obj[allCheckObj[i]];
									break;
							}	
						}
						var msg = "Please select one option"
						if (!isSelected){
							alert(msg);
							return false;
						}else{
							sendSystemEventToServer_LogExt("RATING_ENDED",logExtCurrentSystemEvent.id,selectedObj.id);
							return true;
						}
					};
					
					allQuestionnaiesResetFunctions[questionnaire.id] = function(){
						for (i=1;i<allCheckObj.length;i++){
							var obj = document.getElementById(allCheckObj[i]);
							obj.style.opacity=ratings_low_opt;
							if (obj.filters)
							{
								obj.filters.alpha.opacity=ratings_low_opt*100;
							}
							logExt_ratings_selected[allCheckObj[i]] = false;
							logExt_ratings_selected_obj[allCheckObj[i]] = null;
							
						}
					}
				}else if (questionnaire.rating.type == "Likert"){
					var HTMLDialogBody = "";
					var HTMLDialogBodyH = "";
					HTMLDialogBody += "<table id=ratings cellspacing=0 cellpadding=0 border=0>";
					HTMLDialogBodyH += "<tr bgcolor='#dddddd' valign=middle>";
					HTMLDialogBodyH += "<td width='25px'>&nbsp;</td>";
					HTMLDialogBodyH += "<td>&nbsp;</td>";
					HTMLDialogBodyH += "<td width='100px'>&nbsp;</td>";
					for (i = 1;i<=questionnaire.rating.size;i++){
						HTMLDialogBodyH += "<th scope='col'>"+i+"</th>";
					}
					HTMLDialogBodyH += "<td width='100px'>&nbsp;</td>";
					if (questionnaire.rating.showNA == "true"){
						HTMLDialogBodyH += "<th>NA</th>";
					}
				    HTMLDialogBodyH += "</tr>"
					HTMLDialogBody += HTMLDialogBodyH;

					var inputList = new Array();
					var rowColor = "bgcolor ='#cccccc'";
					var j = 1;
					jQuery.each(questionnaire.questions, function(name, question) {
						HTMLDialogBody += "<tr "+((j % 2)==0?rowColor:'')+" valign=middle height='25px'>"
						HTMLDialogBody += "<td align=left> <a name=logExt_"+ques_id+"_"+question.id+">"+j+".</a> </td>"; 
						HTMLDialogBody += "<td align=left> <label for=logExt_"+ques_id+"_"+question.id+">"+question.title+"</label></td> ";
						if(!containsArrayEntry_LogExt(LogExt_divs, "logExt_"+ques_id+"_"+question.id)){
								LogExt_divs.push("logExt_"+ques_id+"_"+question.id);
						}
						HTMLDialogBody += "<td align=right><font size='-1'>"+questionnaire.rating.startTitle + "</font></td> ";
						inputList[j] = "logExt_"+ques_id+"_"+question.id;
						for (i = 1;i<=questionnaire.rating.size;i++){
							var title = "";
							if (i == 1){
								title = "title='"+i+" ("+questionnaire.rating.startTitle+")'";
							}else if (i == questionnaire.rating.size){
								title = "title='"+i+" ("+questionnaire.rating.endTitle+")'";
							}
							
							HTMLDialogBody += "<td><input type='radio' id='logExt_"+ques_id+"_"+question.id+"_"+i+"' name='logExt_"+ques_id+"_"+question.id+"' "+title+" value='"+i+"' ></td>";
							if(!containsArrayEntry_LogExt(LogExt_divs, "logExt_"+ques_id+"_"+question.id+"_"+i)){
								LogExt_divs.push("logExt_"+ques_id+"_"+question.id+"_"+i);
							}
						}
						HTMLDialogBody += "<td align=right><font size='-1'>"+questionnaire.rating.endTitle + "</font></td> ";
						if (questionnaire.rating.showNA == "true"){
							HTMLDialogBody += "<td><input type=radio title='For items that are not applicable, use: NA' id=logExt_"+ques_id+"_"+question.id+" name=logExt_"+ques_id+"_"+question.id+" value='0' ></td>" ;
						}
						
						HTMLDialogBody += "</tr>";
						j++;
					});
					HTMLDialogBody += HTMLDialogBodyH;
					HTMLDialogBody += "</table> ";
					
					if (questionnaire.showComment){
						HTMLDialogBody += "Comments: <textarea style='width:400px' id='comments' ></textarea> ";
					}
					
					$('#'+ques_id).prepend(HTMLDialogBody);
					
					validateFunction[questionnaire.id] = function() {
							var hasError = false;
							var msg = "Please answer the following question(s):";
							for (i=1;i<inputList.length;i++){
								if (!$('input:radio[name='+inputList[i]+']:checked').val()){
									if (!hasError){
										msg = msg + " Q" +i ;
									}else{
										msg = msg + ", Q" +i ;
									}
									hasError = true;
								
								}
							}
							msg =  msg + ".";
						if (hasError){
							alert(msg);
							return false;
						}else{
							
							
							var selectedIds = "";
							var first = true;
							for (i=1;i<inputList.length;i++){
								var val = $('input:radio[name='+inputList[i]+']:checked').val();
								
								if (!first) selectedIds += "-";
								selectedIds += inputList[i] +":" + val ;
								first = false;
							}
						
							sendSystemEventToServer_LogExt("RATING_ENDED",logExtCurrentSystemEvent.id,selectedIds);
							
							return true;
						}
					}
					
					allQuestionnaiesResetFunctions[questionnaire.id] = function(){
						for (i=1;i<inputList.length;i++){
							$('input:radio[name='+inputList[i]+']').attr('checked', false);
						}
					}
					
	
				}
	
				// Render the Dialog
				$('#'+ques_id).dialog({autoOpen: false, modal:true,zIndex: 2000,width:'auto', buttons: { "Submit": function() { 
					
					if (validateFunction[$('#'+ques_id).data('questionnaireId')]()){
						$(this).dialog("close");
					}		
				
				 } } , closeOnEscape: false,  open: function(event, ui) { $(".ui-dialog-titlebar-close").hide();}
						
				 });
				 
				 allQuestionnaiesId[k] = questionnaire.id;
				 k++;
	
			});
			
			
	});
}









