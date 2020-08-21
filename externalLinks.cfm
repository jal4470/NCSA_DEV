<!--- 
	FileName:	homesite+\html\Default Template.htm
	Created on: mm/dd/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments
5/28/2010 B. Cooper
8005 - added external links to forms manager

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">

<cfoutput>
<div id="contentText">

<H1 class="pageheading">NCSA - External Links</H1>
<br>
 	<!--- <table border="0" cellpadding="0" cellspacing="5" width="50%" align="left">
		<!--- <tr><td><a href="http://www.njyouthsoccer.com" target="_blank">	<img src="#SESSION.sitevars.imagePath#njys.JPG" border="0" height="30">	</a> </td>
			<td><a href="http://www.njyouthsoccer.com" target="_blank">	New Jersey Youth Soccer										</a> </td>
		</tr> --->
		<tr><td><a href="http://www.usclubsoccer.org" target="_blank">	&nbsp; </td>
			<td><a href="http://www.usclubsoccer.org" target="_blank">	US Club Soccer										</a> </td>
		</tr>
		<tr><td><a href="http://www.USYouthSoccer.org" target="_blank">	<img src="#SESSION.sitevars.imagePath#usyouthsoccer.JPG" border="0" height="30"></a></td>
			<td><a href="http://www.USYouthSoccer.org" target="_blank">	US Youth Soccer Online												</a> </td>
		</tr>
		<tr><td><a href="http://www.USSoccer.com" target="_blank">		<img src="#SESSION.sitevars.imagePath#ussoccer.JPG" border="0" height="30">	</a></td>
			<td><a href="http://www.USSoccer.com" target="_blank">		US Soccer Federation											</a> </td>
		</tr>
		<tr><td><a href="http://www.fifa.com" target="_blank">			<img src="#SESSION.sitevars.imagePath#Fifa.JPG" border="0" height="30">	</a></td>
			<td><a href="http://www.fifa.com" target="_blank">			Federation Internationale de Football Association			</a> </td>
		</tr>
		<tr><td><a href="http://www.USSoccerFoundation.org" target="_blank">	<img src="#SESSION.sitevars.imagePath#USSoccerFoundation.JPG" border="0" height="30"></a></td>
			<td><a href="http://www.USSoccerFoundation.org" target="_blank">	US Soccer Foundation													</a> </td>
		</tr>
		<tr><td><a href="http://www.region1.com/" target="_blank">		<img src="#SESSION.sitevars.imagePath#USYS.JPG" border="0" height="20">	</a></td>
			<td><a href="http://www.region1.com/" target="_blank">		US Youth Soccer Association - Region 1						</a> </td>
		</tr>
		<tr><td><a href="http://www.fifa2.com/scripts/runisa.dll?S7:gp::67173+refs/laws" target="_blank">	<img src="#SESSION.sitevars.imagePath#LawsOfTheGames.JPG" border="0" height="30"></a></td>
			<td><a href="http://www.fifa2.com/scripts/runisa.dll?S7:gp::67173+refs/laws" target="_blank">	Laws of the Game													 </a> </td>
		</tr>
		<tr><td><a href="http://www.ucs.mun.ca/~dgraham/manual/" target="_blank">	<img src="#SESSION.sitevars.imagePath#SoccerCoach.JPG" border="0" height="30">	</a></td>
			<td><a href="http://www.ucs.mun.ca/~dgraham/manual/" target="_blank">	Soccer-Coach-L Soccer Coaching Manual								</a> </td>
		</tr>
		<tr><td><a href="http://www.ucs.mun.ca/~dgraham/lotg/" target="_blank">		<img src="#SESSION.sitevars.imagePath#SoccerCoach.JPG" border="0" height="30">	</a></td>
			<td><a href="http://www.ucs.mun.ca/~dgraham/lotg/" target="_blank">		FAQ on the Laws of Soccer											</a> </td>
		</tr>
		<tr><td>&nbsp;			</td>
			<td><a href="http://www.backofthenet.com/" target="_blank">	Back of the Net (Index of a neighbourhood)	</a> </td>
		</tr>
	</table> --->

	<cfinvoke component="#SESSION.sitevars.cfcPath#form" method="getForms" returnvariable="forms">
		<cfinvokeargument name="group_id" value="4">
	</cfinvoke>


	<cfloop query="forms">
		<br>
		<br> #repeatString("&nbsp;",5)# <a href="formsView.cfm?form_id=#form_id#">#forms.name#</a><cfif formType EQ 1> (.#forms.extension#)</cfif>
	</cfloop>
	
	
	<div style="border-top:1px solid ##CCCCCC; margin-top:20px; padding-top:30px;">
		<A href="http://www.adobe.com/products/acrobat/readstep2.html" target="_blank">
			<img border="0" src="<cfoutput>#SESSION.sitevars.imagePath#</cfoutput>adobe_reader.gif" width="71" height="27">&nbsp;Download Adobe Acrobat reader
		</A>
	</div>

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
