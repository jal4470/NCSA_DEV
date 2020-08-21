<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 10.26.2006	--->
<!------------------------------------->

 
 <!--- validate login --->
 <cfmodule template="../_checkLogin.cfm">
 
<!--- Set Application variables --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset site_title = application.site_title>
</cflock>

<!--- Security --->
<cfinclude template="_secureme.cfm">

<CFSET error = "">

<!----------------------->
<!--- Local variables --->
<!----------------------->
<CFIF ISDEFINED("url.item")>
	<CFSET item = #url.item#>
<CFELSE>
	<CFSET error = "You are not authorized to view this page">
</CFIF>

<CFIF item IS "">
	<CFSET error = "You are not authorized to view this page">
</CFIF>


<!---------------->
<!--- Get data --->
<!---------------->
<CFTRY>
	<CFQUERY NAME="getitem" DATASOURCE="#dsn#">
		SELECT #item# AS viewitem
		  FROM v_organization
		 WHERE organization_id = #organization_id#
	</CFQUERY>
	<CFCATCH type="any">
		<CF_ERROR error="Cannot get Organization.">			
	</CFCATCH>			
</CFTRY>

<CFIF getitem.recordcount GT 0>
	<CFSET display_content = "#getitem.viewitem#">
<CFELSE>
	<CFSET error = "You are not authorized to view this page">
</CFIF>

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Community Pass</title>
	<link rel="stylesheet" type="text/css" href="style.css" media="print,screen">
	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet" >

</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<!--- Header --->

<table border="0" cellspacing="0" cellpadding="10" width="100%">
	<CFOUTPUT>
	<tr>
		<td><CFIF error IS NOT "">#error#<CFELSE>#display_content#</CFIF></td>
	</tr>
	</CFOUTPUT>
	<tr>
		<td align="center"><a href="javascript:window.close()"><img src="assets/images/but_closewin.gif" alt="" width="94" height="18" border="0"></a></td>
	</tr>
</table>

</body>
</html>
