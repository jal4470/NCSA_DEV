<!--- 
	FileName:	fineDisplay.cfm
	Created on: 10/13/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">
<cfoutput>
<div id="contentText">

<cfif isDefined("URL.fnid") AND isNumeric(URL.fnid)>
	<CFSET fineID = URL.fnid>
<cfelseif isDefined("FORM.FineId") AND isNumeric(FORM.FineId)>
	<CFSET fineID = FORM.FineId>
<CFELSE>
	<cflocation url="finesListAll.cfm">
</cfif>

<H1 class="pageheading">NCSA - Display Fine</H1>
<br> <a href="finePrint.cfm?fnid=#VARIABLES.fineID#" target="_blank">printer friendly version</a> 


<cfinclude template="fineDisplayinclude.cfm">

</cfoutput>
</div>
<cfinclude template="_footer.cfm">
