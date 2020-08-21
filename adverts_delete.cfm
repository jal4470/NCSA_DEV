<!--- 
	FileName:	adverts_delete.cfm
	Created on: 1/24/2011
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfinclude template="_checkLogin.cfm">

<cfinvoke
	component="#application.sitevars.cfcpath#.ad"
	method="deleteAd"
	ad_id="#url.ad_id#">
	
<cflocation url="adverts.cfm" addtoken="No">