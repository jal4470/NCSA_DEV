<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---  Last Modified: 10.26.2006	--->
<!------------------------------------->

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

<!----------------------->
<!--- Local variables --->
<!----------------------->



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
	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet">
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet">
	
</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<CFINCLUDE TEMPLATE="header_nltr.cfm">

<!--- BODY --->
<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<!--- LEFT NAVIGATION --->
		<CF_nltr_navigation securestring="#securestring#" location="suppression" organization_id="#organization_id#" rolelistStr="#rolelistStr#">
		
		</td>
		<td style="padding-top: 10px;padding-right: 10px;" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="controlbar" colspan="2">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<CFOUTPUT>
					<form method="post" action="nltr_subscriber_search_action.cfm?s=#securestring#">
					<input type="hidden" name="nextpage" value="nltr_subscribers.cfm">
					<tr>
						<td width="5" align="left" valign="middle"><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="100" align="left" valign="middle">
						<input type="text" name="searchterm" class="regularfield">
						</td>
						<td width="50" align="left" valign="middle" style="background-image: url(assets/images/searchbutton.jpg);background-repeat: no-repeat;">
						<input type="submit" name="submit" value="Search" class="searchbut">
						</td>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="50" align="right" valign="middle"><img src="assets/icons/admin.gif" alt="" width="21" height="17" border="0"></td>
						<td width="80" align="left" valign="middle" class="controlbartext" onclick="location.href='nltr_admin.cfm?s=#securestring#'">Administration</td>
						<td width="30" align="left" valign="middle"><img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0"></td>
					</tr>
					</form>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
			<tr>
				<td class="emailtablebar">
				<div style="height: 5px;"> </div>
				<CFOUTPUT>
				<form method="post" action="nltr_subscribers_unsubscribe_action.cfm?s=#securestring#">
				<table cellspacing="2" cellpadding="4" border="0" width="100%">
					<tr>
						<td class="formitemlabelwh"></td>
						<td class="formitemwh">Please enter a valid email address below.</td>
					</tr>
					<tr>
						<td class="formitemlabelwh">Email Address:</td>
						<td class="formitemwh"><input type="text" name="email" size="15" class="field200" value=""></td>
					</tr>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
					</tr>
					<tr>
						<td class="formitemlabelwh"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
						<td class="formitemwh"><img src="assets/images/but_email_cancel.gif"  width="72" height="17" onclick="location.href='javascript:history.back()'" border="0" style="cursor: pointer;"> 
						<input type="image" name="Submit" value="Submit" src="assets/images/but_email_save.gif"  width="72" height="17"></td>
					</tr>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="25" border="0"></td>
					</tr>
					</form>
				</table>
				</CFOUTPUT>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

<!--- END BODY --->

<table border="0" cellspacing="0" cellpadding="0" width="100%">
	<tr>
		<td height="26" align="right" style="padding-right: 10px;"><IMG SRC="assets/images/cp_powered2.gif" ALT="" WIDTH="213" HEIGHT="26"></td>
	</tr>
</table>

</body>
</html>
