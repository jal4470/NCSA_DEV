<!--- 
	FileName:	adverts_flip status.cfm
	Created on: 1/25/2011
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfinclude template="_checkLogin.cfm">

<cfinvoke
	component="#application.sitevars.cfcpath#.ad"
	method="flipStatus"
	ad_id="#url.ad_id#">
	
<cflocation url="adverts.cfm" addtoken="No">