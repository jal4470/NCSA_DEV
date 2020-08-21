<!--- 
	FileName:	refLinksPage.cfm
	Created on: 02/27/2009
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<!--- <div id="contentText">

<cfoutput>
<H1 class="pageheading">NCSA - Referee Links</H1>
<br><br>#repeatString("&nbsp;",5)#<a href="http://www.ussoccer.com/referees/index.jsp.html" target="_blank"> USSF Referee Info </a>
<br><br>#repeatString("&nbsp;",5)#<a href="http://www.ussoccer.com/laws/index.jsp.html" target="_blank"> Laws of the Game/USSF Advice Book/Position Papers </a>
<br><br>#repeatString("&nbsp;",5)#<a href="http://www.njrefs.com/" target="_blank"> NJ Referee Committee Site </a>
<br><br>#repeatString("&nbsp;",5)#<a href="http://www.eny-soccer-referees.org/" target="_blank"> ENY Referee Committee Site </a>
</cfoutput>

</div> --->

 <!--- get the forms --->
 <cfinvoke component="#SESSION.sitevars.cfcPath#form" method="getForms" returnvariable="forms">
	<cfinvokeargument name="group_id" value="3">
</cfinvoke>


<cfoutput>
<div class="contentText">
	 
		<H1 class="pageheading">NCSA - Referee Links</H1>
		
		<cfloop query="forms">
			<br>
			<br> #repeatString("&nbsp;",5)# <a href="formsView.cfm?form_id=#form_id#">#forms.name#</a><cfif formType EQ 1> (.#forms.extension#)</cfif>
		</cfloop>
		
		
		<div style="border-top:1px solid ##CCCCCC; margin-top:20px; padding-top:30px;">
			<A href="http://www.adobe.com/products/acrobat/readstep2.html">
				<img border="0" src="<cfoutput>#SESSION.sitevars.imagePath#</cfoutput>adobe_reader.gif" width="71" height="27">&nbsp;Download Adobe Acrobat reader
			</A>
		</div>

</div>
</cfoutput>

<cfinclude template="_footer.cfm">
