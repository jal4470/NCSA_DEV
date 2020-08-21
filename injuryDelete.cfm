<!--- 
	FileName:	injuryDelete.cfm
	Created on: 06/09/2009
	Created by: b. cooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
 <cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfif isdefined("url.injury_id")>

<cfinvoke
	component="#application.sitevars.cfcpath#.injury"
	method="deleteInjury"
	injury_id="#url.injury_id#">

</cfif>


<cflocation url="injuryList.cfm" addtoken="No">