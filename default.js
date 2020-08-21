

function showMenu(menu,selectedItem,tag) 
{
	var allDivs = document.getElementsByTagName(tag);
	var len = allDivs.length;
	for(var x=0;x<len;x++)
	{
		if(allDivs[x].id.substring(0,6) == 'subNav' && tag == 'div' && allDivs[x].id != document.getElementById(menu).id)
		{//alert(allDivs[x].id);
			document.getElementById(allDivs[x].id).style.display='none';
		}
		if(allDivs[x].id.substring(0,8) == 'privMenu' && tag == 'ul' && allDivs[x].id != document.getElementById(menu).id) 
		{
			document.getElementById(allDivs[x].id).style.display='none';
		}
//do whatever you want to do with the singleDiv here
	}
				
	var allAnchors = document.getElementsByTagName('a');	
	var alen = allAnchors.length;
	for(var y=0;y< alen ;y++)
	{
		if (allAnchors[y].id.substring(0,8) == 'menuItem' && tag == 'div')
		{	//document.getElementById(allAnchors[y].id).style.fontWeight='normal';
			document.getElementById(allAnchors[y].id).style.background='';
		}
		if (allAnchors[y].id.substring(0,8) == 'privItem' && tag == 'ul')
		{	//document.getElementById(allAnchors[y].id).style.fontWeight='normal';
		}
	}
			   
	var objBranch = document.getElementById(menu).style;
	if(objBranch.display=='block')
	{	objBranch.display='none';
		document.getElementById(allAnchors[y].id).style.background='';
	}
	else
	{	objBranch.display='block';
	}
	//document.getElementById(selectedItem).style.fontWeight='bold';
	if(tag == 'div')
	{document.getElementById(selectedItem).style.background='#006699';
	}
}


window.onload = function()
{	var lis = document.getElementById('cssdropdown').getElementsByTagName('li');
	for(i = 0; i < lis.length; i++)
	{
		var li = lis[i];
		if (li.className == 'headlink')
		{
			li.onmouseover = function() { this.getElementsByTagName('ul').item(0).style.display = 'block'; }
			li.onmouseout = function() { this.getElementsByTagName('ul').item(0).style.display = 'none'; }
		}
	}
}
/*	// or with jQuery:
	$(document).ready(function(){
		$('#cssdropdown li.headlink').hover(
			function() { $('ul', this).css('display', 'block'); },
			function() { $('ul', this).css('display', 'none'); });
	});*/
		   
