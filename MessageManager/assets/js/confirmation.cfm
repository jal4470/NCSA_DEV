<script type="text/javascript">
function doConfirmation(locstring,recorddata,direct,label){
	
	gostring = locstring + "<CFOUTPUT>?s=#securestring#&nextpage=</CFOUTPUT>" + direct + "&" + recorddata;
	
	var message = "Are you sure you want to remove this " + label + "?";
	var wantToContinue = "false";
	

	wantToContinue = confirm(message);
	
	
	if (wantToContinue == true) { 
		// put whatever you want to happen if someone clicks OK here
		window.location.href=(gostring);
	}else{
		return false;
	}
}
</script>