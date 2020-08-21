<!--- 
	FileName:	standings.cfm
	Created on: 08/13/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: Display Standings based on Division
	
MODS: mm/dd/yyyy - filastname - comments


TODOS: this does not have the logic to display the game details
 --->
 
<cfset mid = 4> 
<cfinclude template="_header.cfm">

<div id="contentText">

<cfoutput>
<H1 class="pageheading">NCSA Game Day Form</H1>
<br>
<H2>click on the link below to download the form.</H2>

<br>
<br>
	<ul>
		<li><a href="#SESSION.sitevars.docpath#matchdayroster.doc" target="_blank">game day form</a></li>
	</ul>
</cfoutput>

</DIV>

<cfinclude template="_footer.cfm">
