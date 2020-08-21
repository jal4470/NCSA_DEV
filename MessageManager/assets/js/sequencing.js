function moveItemTo(where,theForm){
	
	with(theForm){
		
		numSelected = 0;
		
		// clear temp list
		while (tempItems.length > [[0]]){
			tempItems.remove([[0]]);
		}
		
		// loop thru items, put selected item at top if that's where it's supposed to go
		for (i=0;i<items.options.length;i++){
			var current = items.options[i];
			if(current.selected){
				numSelected ++;
			}
			if((current.selected)&&(where == 'top')){
				tempItems.options[tempItems.length] = new Option(current.text,current.value);
			}
		}
		
		// loop thru items, construct list of non-selected
		for (i=0;i<items.options.length;i++){
			var current = items.options[i];
			if(!current.selected){
				tempItems.options[tempItems.length] = new Option(current.text,current.value);
			}
		}
		// loop thru items, put selected item at bottom if that's where it's supposed to go
		for (i=0;i<items.options.length;i++){
			var current = items.options[i];
			if((current.selected)&&(where == 'bottom')){
				tempItems.options[tempItems.length] = new Option(current.text,current.value);
			}
		}
		// clear item list, replace with temp list
		while (items.length > [[0]]){
			items.remove([[0]]);
		}
		for(i=[[0]];i<tempItems.length;i++){
			items.options[items.length] = new Option(tempItems[i].text, tempItems[i].value);
		}
		if(where == 'top'){
			for(i=0;i<numSelected;i++){
				items.options[i].selected = true;
			}
		}else if(where == 'bottom'){
			ind = items.length - 1;
			for(i=0;i<numSelected;i++){
				items.options[ind].selected = true;
				ind = ind - 1;
			}
		}
	}
	
}
			

function listToAlpha(theForm){
	
	selectedItems = new Array();
	
	with(theForm){
		
		// make list of selected items
		for(i=0;i<items.length;i++){
			if(items.options[i].selected == true){
				selectedItems[i] = items[i].value;
			}
		}
		
		// clear items dropdown
		while (items.length > [[0]]){			
			items.remove([[0]]);
		}
		
		// replace items dropdown with values from alpha dropdown in form
		for(i=0;i<alphaItems.length;i++){
			items.options[items.length] = new Option(alphaItems[i].text, alphaItems[i].value);
		}
		
		// select the items that the user had selected before
		for(i=0;i<items.options.length;i++){

			for(j=0;j<selectedItems.length;j++){
				if(selectedItems[j] == items.options[i].value){
					items.options[i].selected = true;
				}
			}

		}
	}
}









function moveUp(obj) { 
	obj = (typeof obj == "string") ? document.getElementById(obj) : obj;
	if (obj.tagName.toLowerCase() != "select" && obj.length < 2)
		return false;
	var sel = new Array();
	for (var i=0; i<obj.length; i++) {
		if (obj[i].selected == true) {
			sel[sel.length] = i;
		}
	}
	for (i in sel) {
		if (sel[i] != 0 && !obj[sel[i]-1].selected) {
			var tmp = new Array((document.body.innerHTML ? obj[sel[i]-1].innerHTML : obj[sel[i]-1].text), obj[sel[i]-1].value, obj[sel[i]-1].style.color, obj[sel[i]-1].style.backgroundColor, obj[sel[i]-1].className, obj[sel[i]-1].id);
			if (document.body.innerHTML) obj[sel[i]-1].innerHTML = obj[sel[i]].innerHTML;
			else obj[sel[i]-1].text = obj[sel[i]].text;
			obj[sel[i]-1].value = obj[sel[i]].value;
			obj[sel[i]-1].style.color = obj[sel[i]].style.color;
			obj[sel[i]-1].style.backgroundColor = obj[sel[i]].style.backgroundColor;
			obj[sel[i]-1].className = obj[sel[i]].className;
			obj[sel[i]-1].id = obj[sel[i]].id;
			if (document.body.innerHTML) obj[sel[i]].innerHTML = tmp[0];
			else obj[sel[i]].text = tmp[0];
			obj[sel[i]].value = tmp[1];
			obj[sel[i]].style.color = tmp[2];
			obj[sel[i]].style.backgroundColor = tmp[3];
			obj[sel[i]].className = tmp[4];
			obj[sel[i]].id = tmp[5];
			obj[sel[i]-1].selected = true;
			obj[sel[i]].selected = false;
		}
	}
}

function moveDown(obj) {
	obj = (typeof obj == "string") ? document.getElementById(obj) : obj;
	if (obj.tagName.toLowerCase() != "select" && obj.length < 2)
		return false;
	var sel = new Array();
	for (var i=obj.length-1; i>-1; i--) {
		if (obj[i].selected == true) {
			sel[sel.length] = i;
		}
	}
	for (i in sel) {
		if (sel[i] != obj.length-1 && !obj[sel[i]+1].selected) {
			var tmp = new Array((document.body.innerHTML ? obj[sel[i]+1].innerHTML : obj[sel[i]+1].text), obj[sel[i]+1].value, obj[sel[i]+1].style.color, obj[sel[i]+1].style.backgroundColor, obj[sel[i]+1].className, obj[sel[i]+1].id);
			if (document.body.innerHTML) obj[sel[i]+1].innerHTML = obj[sel[i]].innerHTML;
			else obj[sel[i]+1].text = obj[sel[i]].text;
			obj[sel[i]+1].value = obj[sel[i]].value;
			obj[sel[i]+1].style.color = obj[sel[i]].style.color;
			obj[sel[i]+1].style.backgroundColor = obj[sel[i]].style.backgroundColor;
			obj[sel[i]+1].className = obj[sel[i]].className;
			obj[sel[i]+1].id = obj[sel[i]].id;
			if (document.body.innerHTML) obj[sel[i]].innerHTML = tmp[0];
			else obj[sel[i]].text = tmp[0];
			obj[sel[i]].value = tmp[1];
			obj[sel[i]].style.color = tmp[2];
			obj[sel[i]].style.backgroundColor = tmp[3];
			obj[sel[i]].className = tmp[4];
			obj[sel[i]].id = tmp[5];
			obj[sel[i]+1].selected = true;
			obj[sel[i]].selected = false;
		}
	}
}


// build list in hidden field
function buildList(theForm)
{
    // clear hidden input
    theForm.elements['orderedItems'].value = '';

    // concatenate list item (in order) to hidden input using CSVs
    var i = [[0]];
    for (i=[[0]];i<theForm.elements['items'].length;i++)
    	theForm.elements['orderedItems'].value += theForm.elements['items'].options[i].value + ',';

	// remove trailing comma
	var list_length = theForm.elements['orderedItems'].value.length;
	if (list_length > [[0]])
	{
	    if (theForm.elements['orderedItems'].value[list_length - [[1]]] == ',')
	        theForm.elements['orderedItems'].value = theForm.elements['orderedItems'].value.substring([[0]], list_length - [[1]]);
	}
}