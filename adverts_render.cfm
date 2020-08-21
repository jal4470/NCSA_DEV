<!--- 
	FileName:	adverts_render.cfm
	Created on: 1/25/2011
	Created by: bcooper
	
	Purpose: [purpose of the file]
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<!--- get ad --->
<cfinvoke
	component="#application.sitevars.cfcpath#.ad"
	method="getAd"
	ad_id="#url.adid#"
	returnvariable="theAd">


<cfif not isdefined("url.notrack")>
	<!--- track click --->
	<cfinvoke
		component="#application.sitevars.cfcpath#.ad"
		method="logClick"
		ad_id="#url.adid#">
</cfif>

<!--- redirect or display page --->
<cfif theAd.customContent NEQ "">
	<cfoutput>#theAd.customContent#</cfoutput>
<cfelseif theAd.href NEQ "">
	<cflocation url="#theAd.href#" addtoken="No">
</cfif>

<!--- we shouldn't get here --->