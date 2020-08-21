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
<CFIF ISDEFINED("url.image")>
	<CFSET image = #url.image#>
<CFELSE>
	<CFSET error = "You are not authorized to view this page">
</CFIF>

<CFIF image IS "">
	<CFSET error = "You are not authorized to view this page">
</CFIF>


<!---------------->
<!--- Get data --->
<!---------------->

<!----------------->
<!--- Page body --->
<!----------------->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Community Pass</title>
	<link rel="stylesheet" type="text/css" href="style.css" media="print,screen">

</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<!--- Header --->

<table border="0" cellspacing="0" cellpadding="10" width="100%">
	<CFOUTPUT>
	<tr>
		<td align="center"><CFIF error IS NOT "">#error#<CFELSE><img src="view_asset.cfm?asset_id=#image#" alt="" border="0"></CFIF></td>
	</tr>
	</CFOUTPUT>
	<tr>
		<td align="center"><a href="javascript:window.close()"><img src="assets/images/but_closewin.gif" alt="" width="94" height="18" border="0"></a></td>
	</tr>
</table>

</body>
</html>
