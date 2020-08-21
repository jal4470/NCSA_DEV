<!------------------------------------->
<!---  Capturepoint.com          	--->
<!---  CRS Action Page		   		--->
<!------------------------------------->
<!---  Created:  10.24.2006 by		--->
<!---	         Pat Waters			--->
<!---
MODIFICATIONS
12/15/2009 P Waters
- Commented out "Track Opens" checkbox
									--->
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

<!----------------------->
<!--- Local variables --->
<!----------------------->
<CFSET default_from_email = "">
<CFSET default_from_alias = "">
<CFSET default_replyto_email = "">
<CFSET default_replyto_alias = "">
<CFSET default_track_opens = "">

<!---------------->
<!--- Get data --->
<!---------------->
<CFTRY>
	<CFINVOKE component="#application.CRS_CFC_Path#GetOrgInfo" method="GetOrgNewsDefaults" returnvariable="orgdefaults">
		<cfinvokeargument name="organization_id" value="#organization_id#">
	</CFINVOKE>

	<CFCATCH type="any">
		<CF_ERROR error="Cannot get Organization Signup.">			
	</CFCATCH>			
</CFTRY>

<CFSET default_from_email = "#orgdefaults.def_news_from_email#">
<CFSET default_from_alias = "#orgdefaults.def_news_from_alias#">
<CFSET default_replyto_email = "#orgdefaults.def_news_replyto_email#">
<CFSET default_replyto_alias = "#orgdefaults.def_news_replyto_alias#">
<CFSET default_track_opens = "#orgdefaults.def_track_opens#">

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

<CFINCLUDE TEMPLATE="header_nltr.cfm">

<!--- BODY --->
<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<!--- LEFT NAVIGATION --->
		<CF_nltr_navigation securestring="#securestring#" location="admin" organization_id="#organization_id#" rolelistStr="#rolelistStr#">
		
		</td>
		<td style="padding-top: 10px;padding-right: 10px;" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="controlbar" colspan="2">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<CFOUTPUT>
					<tr>
						<td width="250" align="left" valign="middle" style="background-image: url(assets/images/emailbarback.jpg);background-repeat:repeat-x;height:28px;">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td width="250" align="left" valign="middle" class="bartitle">Administration - Defaults</td>
							</tr>
						</table>
						</td>
						<td><img src="assets/images/spcrimg.gif" alt="" width="1" height="3" border="0"></td>
						<td width="50" align="right" valign="middle"><img src="assets/icons/admin.gif" alt="" width="21" height="17" border="0"></td>
						<td width="80" align="left" valign="middle" class="controlbartext" onclick="location.href='nltr_admin.cfm?s=#securestring#'">Administration</td>
						<td width="30" align="left" valign="middle"><img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0"></td>
					</tr>
					</CFOUTPUT>
				</table>
				</td>
			</tr>
			<tr>
				<td class="emailtablebar">
				
				<table border="0" cellspacing="2" cellpadding="4" width="100%">
					<CFOUTPUT>
					<form method="post" action="nltr_edition_defaults_action.cfm?s=#securestring#" ENCTYPE="multipart/form-data">
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="15" border="0"></td>
					</tr>
					<tr>
						<td class="formitemlabelwh">From Email:<img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0" style="vertical-align: bottom"></td>
						<td class="formitemwh"><input type="text" name="from_email" size="40" maxlength="100" class="regularfield" value="#default_from_email#"></td>
					</tr>
					<tr>
						<td class="formitemlabelwh">From Alias:<img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0" style="vertical-align: bottom"></td>
						<td class="formitemwh"><input type="text" name="from_alias" size="40" maxlength="100" class="regularfield" value="#default_from_alias#"></td>
					</tr>
<!---
					<tr>
						<td class="formitemlabelwh">Track Opens:<img src="assets/icons/ques3.gif" alt="" width="21" height="17" border="0" style="vertical-align: bottom"></td>
						<td class="formitemwh"><input type="checkbox" name="track_opens" value="1"<cfif default_track_opens EQ 1> CHECKED</cfif>></td>
					</tr>
--->
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="5" border="0"></td>
					</tr>
					<tr>
						<td class="formitemlabelwh"><img src="assets/images/spcrimg.gif" alt="" width="1" height="1" border="0"></td>
						<td class="formitemwh"><img src="assets/images/but_email_cancel.gif"  width="72" height="17" onclick="location.href='nltr_admin.cfm?s=#securestring#'" border="0" style="cursor: pointer;"> 
						<input type="image" name="Submit" value="Submit" src="assets/images/but_email_save.gif"  width="72" height="17"></td>
					</tr>
					<tr>
						<td colspan="2"><img src="assets/images/spcrimg.gif" alt="" width="1" height="15" border="0"></td>
					</tr>
					</form>
					</CFOUTPUT>
				</table>
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
