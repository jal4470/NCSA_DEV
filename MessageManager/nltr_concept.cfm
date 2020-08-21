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
	<link  href="_newsletter_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link  href="_tooltip_style.css" type="text/css" media="print,screen" rel="stylesheet" >
	<link rel="stylesheet" type="text/css" href="assets/stylesheets/_navigation.css" media="print,screen">
	<script type="text/javascript" src="assets/js/showhide.js"></script>

</head>

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<CFINCLUDE TEMPLATE="header_concept.cfm">
<!--- Header
<table border="0" cellspacing="0" cellpadding="2" width="100%" bgcolor="#6661A7">
	<tr>
		<td width="50%" align="left" class="whitebold12" style="padding-left: 15px; height: 20px;">Newsletter Management - Messages</td>
		<td width="50%" align="right" class="whitebold12" style="padding-right: 10px; height: 20px;"><cfoutput>#organization_desc#</cfoutput></td>
	</tr>
</table>
 --->
<!--- BODY --->


<table border="0" cellspacing="0" cellpadding="2" width="100%">
	<tr>
		<td style="padding-left: 15px; padding-top: 10px;" valign="top" width="150">
		
		<table cellpadding="3" border="0" cellspacing="0" width="148">
			<CFOUTPUT>
			<tr>
				<td class="emailnavtopleft"><img src="assets/icons/messages.gif" alt="" width="21" height="17" border="0"></td>
				<td class="emailnavtopright" onclick="location.href='nltr_view_drafts.cfm?s=#securestring#'">Messages</td>
			</tr>
			<tr>
				<td class="emailnavbotleft"><img src="assets/icons/subs.gif" alt="" width="21" height="17" border="0"></td>
				<td class="emailnavbotright" onclick="location.href='nltr_recipients.cfm?s=#securestring#'">Subscribers</td>
			</tr>
			<tr>
				<td class="emailnavbotleft"><img src="assets/icons/report.gif" alt="" width="21" height="17" border="0"></td>
				<td class="emailnavbotright">Reports</td>
			</tr>
			</CFOUTPUT>
		</table>
		
		</td>
		<td style="padding-top: 10px;padding-right: 10px;" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td class="controlbar" colspan="2">
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<CFOUTPUT>
					<form method="post" action="nltr_new_message.cfm?s=#securestring#">
					<tr>
						<td width="70" align="left" valign="middle" style="background-image: url(assets/images/emailbarback.jpg);background-repeat:repeat-x;height:28px;">
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td width="99" align="left" valign="middle" class="bartitle">Administration</td>
							</tr>
						</table>
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
				
				<table border="0" cellspacing="0" cellpadding="3" width="100%">
					<tr>
						<td style="padding-left:20px; padding-top:15px;"><b>Public Newsletter Sign-Up Form</b></td>
					</tr>
					<CFOUTPUT>
					<tr>
						<td style="padding-left:40px;"><a href="nltr_control_general.cfm?s=#securestring#">General Controls</a></td>
					</tr>
					<tr>
						<td style="padding-left:40px;"><a href="nltr_control_login.cfm?s=#securestring#">Login Page Messages</a></td>
					</tr>
					<tr>
						<td style="padding-left:40px;"><a href="nltr_control_signup.cfm?s=#securestring#">New subscriber sign-up messages</a></td>
					</tr>
					<tr>
						<td style="padding-left:40px;"><a href="nltr_control_signup_ret.cfm?s=#securestring#">Returning subscriber messages</a></td>
					</tr>
					<tr>
						<td style="padding-left:40px;"><a href="nltr_control_topics.cfm?s=#securestring#">Newsletter Topics</a></td>
					</tr>
					<tr>
						<td style="padding-left:40px;"><a href="nltr_control_thankyou.cfm?s=#securestring#">Thank You page messages</a></td>
					</tr>
					<tr>
						<td style="padding-left:20px; padding-top:15px;"><b>Email Newsletter</b></td>
					</tr>
					<tr>
						<td style="padding-left:40px; padding-bottom:30px;"><a href="nltr_edition_defaults.cfm?s=#securestring#">Edition default settings</a></td>
					</tr>
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
