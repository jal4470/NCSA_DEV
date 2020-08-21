

<cfscript>

function setRowColor(lColors,RowNum) 
{	var rowColor="";
    var x=1;
    x=RowNum MOD ListLen(lColors) + 1;
    setColor=  ListGetAt(lColors,x);
    return setColor;
}


function fieldSizeText(size)
{	var fText = "";
	switch(size) 
	{	case "L":
	        fText="Large Field (11 vs 11)";
	        break;
		case "S":
	        fText="Small Field (8 vs 8)";
	        break;
		case "B":
	        fText="Both (Small & Large)";
	        break;
 	   default:
			fText="";
	} //end switch
	return fText;
}

</cfscript>