<html>
<head>
	<title>CommunityPass Error Page</title>
	<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<!--- Set application variables --->
<cfif not isdefined("application.dsn")>
	<cfinclude template="application.cfm">
</cfif>
<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset crs_api_path = application.crs_api_path>
	<cfset Security_API_Path = application.Security_API_Path>
</cflock>

<!--------------------->
<!--- Set variables --->
<!--------------------->
<!--- errormessage --->
<cfif isdefined("attributes.error")>
	<cfset errormessage = attributes.error>
<cfelseif isdefined("url.error")>
	<cfset errormessage = url.error>
<cfelseif isdefined("form.error")>
	<cfset errormessage = form.error>
<cfelse>
	<cfset errormessage = "An unknown error has occurred">
</cfif>

<!--- ui_page --->
<cfif isdefined("attributes.UI_page")>
	<cfset ui_page = attributes.UI_page>
<cfelse>
	<cfset ui_page = "">
</cfif>

<!--- session_id --->
<cfif isdefined("attributes.session_id")>
	<cfset session_id = attributes.session_id>
<cfelse>
	<cfset session_id = "">
</cfif>

<!--- errorcode --->
<cfif isdefined("attributes.code")>
	<cfset errorcode = attributes.code>
<cfelse>
	<cfset errorcode = "">
</cfif>

<!--- function --->
<cfif isdefined("attributes.function")>
	<cfset function = attributes.function>
<cfelse>
	<cfset function = "">
</cfif>

<!-------------------------------------->
<!--- New variables  (added 2/17 PW) --->
<!-------------------------------------->
<!--- linktext1 --->
<cfif isdefined("attributes.linktext1")>
	<cfset linktext1 = attributes.linktext1>
<cfelse>
	<cfset linktext1 = "BACK">
</cfif>

<!--- linkurl1 --->
<cfif isdefined("attributes.linkurl1")>
	<cfset linkurl1 = attributes.linkurl1>
<cfelse>
	<cfset linkurl1 = "javascript:history.back()">
</cfif>

<!--- linktext2 --->
<cfif isdefined("attributes.linktext2")>
	<cfset linktext2 = attributes.linktext2>
<cfelse>
	<cfset linktext2 = "">
</cfif>

<!--- linkurl2 --->
<cfif isdefined("attributes.linkurl2")>
	<cfset linkurl2 = attributes.linkurl2>
<cfelse>
	<cfset linkurl2 = "">
</cfif>

<!---------------------------------------------->
<!--- Log error (only if session_id defined) --->
<!---------------------------------------------->
<cfif session_id NEQ "">
<cftry>
	<CFHTTP METHOD="POST" URL="#security_api_path#/RecordError.cfm" redirect="NO" throwonerror="Yes">
		<CFHTTPPARAM NAME="UI_page" TYPE="FormField" VALUE="#UI_page#">
		<CFHTTPPARAM NAME="error_message" TYPE="FormField" VALUE="#errormessage#">
		<CFHTTPPARAM NAME="session_id" TYPE="FormField" VAlue="#session_id#">
		<CFHTTPPARAM NAME="function" TYPE="FormField" VALUE="#function#">
		<CFHTTPPARAM NAME="errorcode" TYPE="FormField" VAlue="#errorcode#">
	</CFHTTP>

	<cfif cfhttp.filecontent CONTAINS "HTTP/1.0 404 Object Not Found">
		<cfthrow message="Error page not found">
	</cfif>
	<cfset status = getToken(cfhttp.filecontent,"1",",")>
	<cfset returncode = getToken(cfhttp.filecontent,"2",",")>
	<cfif trim(status) EQ "SUCCESS">
		<cfset errorcode = returnCode>
	</cfif>

	<cfcatch>
		<!--- do nothing --->
	</cfcatch>
</cftry>
</cfif>

<!-------------------->
<!--- Body of page --->
<!-------------------->

<!--- Header --->
<cfif isdefined("url.s") AND isdefined("rolelist")>
 <CFINCLUDE TEMPLATE="header.cfm">
<cfelse>
 <CFINCLUDE TEMPLATE="header_login.cfm">
</cfif>

<table border="0" cellspacing="0" cellpadding="0" width="780">
	<tr>
		<td height="10"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="10"></td>
	</tr>
	<tr>
		<td width="780" valign="top" bgcolor="#E6E7E8">
		<table border="0" cellspacing="0" cellpadding="0" width="780">
			<tr>
				<td width="10"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
				<td width="770" valign="top">
				<table border="0" cellspacing="0" cellpadding="0" width="770">
					<tr>
						<td colspan="3" height="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
					</tr>
					<tr>
						<td width="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
						<td width="768">
						<table border="0" cellspacing="0" cellpadding="4" width="768" bgcolor="#FFFFFF">
							<tr>
								<td height="15" valign="middle" bgcolor="#6661A7" class="whitebold14">We're Sorry</td>
							</tr>
						</table>
						<table border="0" cellspacing="0" cellpadding="0" width="768" bgcolor="#FFFFFF">
							<tr>
								<td height="10" colspan="3"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="10"></td>
							</tr>
							<tr>
								<td width="10"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="10" HEIGHT="1"></td>
								<td width="748" valign="top">
								<table border="0" cellspacing="0" cellpadding="0" width="450">
									<tr>
										<td width="30"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="30" HEIGHT="1"></td>
										<td colspan="3" height="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
									</tr>
									<tr>
										<td colspan="4" height="5"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="5"></td>
									</tr>
									<cfoutput>
									<tr>
										<td width="30"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="30" HEIGHT="1"></td>
										<td width="21" align="right" valign="top"><IMG SRC="assets/images/alert_dia.gif" ALT="" WIDTH="21" HEIGHT="21"></td>
										<td width="5"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="5" HEIGHT="1"></td>
										<td valign="middle" class="bigcopyblack" width="394"><b class="bigbold">#errormessage#</b></td>
									</tr>
									<tr>
										<td colspan="4" height="5"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="5"></td>
									</tr>
									<tr>
										<td width="30"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="30" HEIGHT="1"></td>
										<td colspan="3" height="1" bgcolor="##636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
									</tr>
									<tr>
										<td colspan="4" height="20"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="20"></td>
									</tr>
									<tr>
										<td width="30"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="30" HEIGHT="1"></td>
										<td width="21" align="right" valign="top"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
										<td width="5"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="5" HEIGHT="1"></td>
										<td valign="top" class="bigcopyblack" width="394">
										<CFIF linktext1 IS NOT "BACK">
										<a href="#linkurl1#" class="bigbluebold">#linktext1#</a>
										<CFELSE>
										Please <a href="#linkurl1#" class="bigbluebold">Click Here</a> to continue.
										</CFIF>
										<cfif linktext2 NEQ "" AND linkURL2 NEQ "">
										&nbsp;
										<a href="#linkurl2#" class="bigbluebold">#linktext2#</a>
										</cfif>
										</td>
									</tr>
									<tr>
										<td colspan="4" height="90"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="90"></td>
									</tr>
									<tr>
										<td width="30"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="30" HEIGHT="1"></td>
										<td width="21" align="right" valign="top"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
										<td width="5"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="5" HEIGHT="1"></td>
										<td valign="top" class="footnoteblack" width="394"><cfif errorcode NEQ "">Error code: #errorcode#<cfelse><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></cfif></td>
									</tr>
									</cfoutput>
									<tr>
										<td height="25" colspan="4"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="25"></td>
									</tr>
								</table>
								</td>
								<td width="10"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="10" HEIGHT="1"></td>
							</tr>
							<tr>
								<td height="50" colspan="3"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="50"></td>
							</tr>
						</table>
						</td>
						<td width="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
					</tr>
					<tr>
						<td colspan="3" height="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="780">
	<tr>
		<td height="26" align="right"><IMG SRC="assets/images/cp_powered2.gif" ALT="" WIDTH="213" HEIGHT="26"></td>
	</tr>
</table>
</body>
</html>

<cfabort>
