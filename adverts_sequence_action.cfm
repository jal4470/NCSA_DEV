<cfdump var=#form#>


<!--- loop over sequence string, save to db --->
<cfset order=1>
<cfloop list="#form.sequence#" delimiters="&" index="i">
	<cfset ad_id=gettoken(i,2,"=")>
	<cfinvoke
		component="#application.sitevars.cfcpath#.ad"
		method="setAdSequence"
		ad_id="#ad_id#"
		sequence="#order#">
	<cfset order=order + 1>
</cfloop>

<cflocation url="adverts.cfm" addtoken="No">