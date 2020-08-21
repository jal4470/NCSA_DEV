<html>
<head>
	<title>Message Manager</title>
	<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0" bgcolor="#FFFFFF">

<!--- Set application variables --->

<cflock scope="application" type="readonly" timeout="10">
	<cfset dsn = application.dsn>
	<cfset crs_api_path = application.mm_api_path>
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
<cfelseif isdefined("url.UI_page")>
	<cfset ui_page = url.UI_page>
<cfelse>
	<cfset ui_page = "">
</cfif>

<!--- session_id --->
<cfif isdefined("attributes.session_id")>
	<cfset session_id = attributes.session_id>
<cfelseif isdefined("url.session_id")>
	<cfset session_id = url.session_id>
<cfelse>
	<cfset session_id = "">
</cfif>

<!--- errorcode --->
<cfif isdefined("attributes.code")>
	<cfset errorcode = attributes.code>
<cfelseif isdefined("url.code")>
	<cfset errorcode = url.code>
<cfelse>
	<cfset errorcode = "">
</cfif>

<!--- function --->
<cfif isdefined("attributes.function")>
	<cfset function = attributes.function>
<cfelseif isdefined("url.function")>
	<cfset function = url.function>
<cfelse>
	<cfset function = "">
</cfif>

<!-------------------------------------->
<!--- New variables  (added 2/17 PW) --->
<!-------------------------------------->
<!--- linktext1 --->
<cfif isdefined("attributes.linktext1")>
	<cfset linktext1 = attributes.linktext1>
<cfelseif isdefined("url.linktext1")>
	<cfset linktext1 = url.linktext1>
<cfelse>
	<cfset linktext1 = "BACK">
</cfif>

<!--- linkurl1 --->
<cfif isdefined("attributes.linkurl1")>
	<cfset linkurl1 = attributes.linkurl1>
<cfelseif isdefined("url.linkurl1")>
	<cfset linkurl1 = url.linkurl1>
<cfelse>
	<cfset linkurl1 = "javascript:history.back()">
</cfif>

<!--- linktext2 --->
<cfif isdefined("attributes.linktext2")>
	<cfset linktext2 = attributes.linktext2>
<cfelseif isdefined("url.linktext2")>
	<cfset linktext2 = url.linktext2>
<cfelse>
	<cfset linktext2 = "">
</cfif>

<!--- linkurl2 --->
<cfif isdefined("attributes.linkurl2")>
	<cfset linkurl2 = attributes.linkurl2>
<cfelseif isdefined("url.linkurl2")>
	<cfset linkurl2 = url.linkurl2>
<cfelse>
	<cfset linkurl2 = "">
</cfif>

<!---------------------------------------------->
<!--- Log error (only if session_id defined) --->
<!---------------------------------------------->


<!-------------------->
<!--- Body of page --->
<!-------------------->

<!--- CHECK TO SEE IF HANDHELD DEVICE --->
<CFIF http_user_agent DOES NOT CONTAIN "Windows CE">

<!--- Header --->
<CFINCLUDE TEMPLATE="header_nltr.cfm">

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


<CFELSE>
<!--- DISPLAY ERROR FOR HANDHELD --->

<table border="0" cellspacing="0" cellpadding="0" width="220">
	<tr>
		<td width="220" valign="top" bgcolor="#E6E7E8">
		<table border="0" cellspacing="0" cellpadding="0" width="220">
			<tr>
				<td width="220" valign="top">
				<table border="0" cellspacing="0" cellpadding="0" width="210">
					<tr>
						<td colspan="3" height="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
					</tr>
					<tr>
						<td width="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
						<td width="208">
						<table border="0" cellspacing="0" cellpadding="4" width="208" bgcolor="#FFFFFF">
							<tr>
								<td height="15" valign="middle" bgcolor="#6661A7" class="headtitletext">We're Sorry</td>
							</tr>
						</table>
						<table border="0" cellspacing="0" cellpadding="0" width="208" bgcolor="#FFFFFF">
							<tr>
								<td height="10" colspan="3"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="10"></td>
							</tr>
							<tr>
								<td width="2"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="2" HEIGHT="1"></td>
								<td width="204" valign="top">
								<table border="0" cellspacing="0" cellpadding="0" width="204">
									<tr>
										<td colspan="3" height="1" bgcolor="#636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
									</tr>
									<tr>
										<td colspan="3" height="5"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="5"></td>
									</tr>
									<cfoutput>
									<tr>
										<td width="21" align="right" valign="top"><IMG SRC="assets/images/alert_dia.gif" ALT="" WIDTH="21" HEIGHT="21"></td>
										<td width="5"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="5" HEIGHT="1"></td>
										<td valign="middle" width="178">#errormessage#</td>
									</tr>
									<tr>
										<td colspan="3" height="5"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="5"></td>
									</tr>
									<tr>
										<td colspan="3" height="1" bgcolor="##636466"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
									</tr>
									<tr>
										<td colspan="3" height="20"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="20"></td>
									</tr>
									<tr>
										<td align="right" valign="top"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
										<td><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="5" HEIGHT="1"></td>
										<td valign="top">
										<CFIF linktext1 IS NOT "BACK">
										<a href="#linkurl1#" class="bigbluebold">#linktext1#</a>
										<CFELSE>
										<a href="#linkurl1#" class="bigbluebold"><img src="assets/images/but_or_continue.gif" alt="" width="82" height="20" border="0"></a>
										</CFIF>
										<cfif linktext2 NEQ "" AND linkURL2 NEQ "">
										&nbsp;
										<a href="#linkurl2#" class="bigbluebold">#linktext2#</a>
										</cfif>
										</td>
									</tr>
									<tr>
										<td colspan="3" height="10"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="10"></td>
									</tr>
									<tr>
										<td align="right" valign="top"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
										<td><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="5" HEIGHT="1"></td>
										<td class="footnoteblack" width="394"><cfif errorcode NEQ "">Error code: #errorcode#<cfelse><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></cfif></td>
									</tr>
									</cfoutput>
									<tr>
										<td height="5" colspan="3"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="5"></td>
									</tr>
								</table>
								</td>
								<td width="5"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="5" HEIGHT="1"></td>
							</tr>
							<tr>
								<td height="5" colspan="3"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="5"></td>
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



</CFIF>

</body>
</html>

<cfabort>
