
// This function looks for checked radio buttons and sets their bg color on page load.
// Must call function in body tag and pass all radio button GROUP names in.
// body onLoad="checkBg('answer_20855','answer_20859')" etc.
function checkBg(){
	
	// LOOP THRU FUNCTION ARGS (RADIO BUTTON GROUPS)
	for(i=0;i<arguments.length;i++){

		groupID = arguments[i]; alert 
		groupLength = eval("document.forms['menuform']." + groupID + ".length");
		
		// LOOP THRU EACH GROUP OF RADIO BUTTONS
		for(j=0;j<groupLength;j++){

			curItem = eval("document.forms['menuform']." + groupID + "[" + j+ "].value"); 
			curItem = groupID + "_" + curItem; //
			curItem = document.getElementById(curItem);
			
			if (eval("document.forms['menuform']." + groupID + "[" + j+ "].checked") == true) { 
				curItem.className = "mealchoicealton";
			}else{
				curItem.className = "mealchoicealt";
			}
			
		}
	}

}

// THIS FUNCTION sets the bg for all elements in a given group to tan, then sets the 
// newly chosen element background to yellow. Called onClick of radio button. 
// Parameters: ID of the container div and the button group name.
function changeBg(elemID,groupID){
	
	if(document.getElementById(elemID)){

		elem = document.getElementById(elemID); 
		groupLength = eval("document.forms['menuform']." + groupID + ".length");
		
		for(i=0;i<groupLength;i++){
			groupItem = eval("document.forms['menuform']." + groupID + "[" + i+ "].value"); 
			groupItem = groupID + "_" + groupItem;
			
			document.getElementById(groupItem).className = "mealchoicealt";
			
		}
		elem.className = "mealchoicealton";
		
	}
	
	
	
}
