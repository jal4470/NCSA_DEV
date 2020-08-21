<!---
MODIFICATIONS
12/9/2009 P Waters
- Replaced "Email Manager" with "Message Manager"
--->
<!---------------------->
<!--- Display header --->
<!---------------------->
<!--- <table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#FFFFFF">
	<tr>
		<td width="50%" align="left" valign="bottom" style="border-bottom: 1px Solid #A1A1A1;" rowspan="2" height="61"><img src="assets/images/capturepoint_logo.gif" alt="" width="253" height="61" border="0"></td>
		<td width="50%" align="right"" valign="middle" height="21" style="padding-right: 10px;"><CFOUTPUT><a href="home.cfm" class="commonnav">CommunityPass</a> | <a href="#application.admin_url#logout_action.cfm" class="commonnav">Logout</a></CFOUTPUT>  </td>
	</tr>
	<tr>
		<td width="50%" align="right"" valign="bottom" style="border-bottom: 1px Solid #A1A1A1;"><img src="assets/images/people2.jpg" alt="" width="315" height="40" border="0"></td>
	</tr>
</table> --->
<table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#FFFFFF">
	<tr>
		<td bgcolor="#9A96CB">
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
			<cfoutput>
			<tr>
				<!--- Home --->
				<CFOUTPUT>
				<td class="buttonbaract" width="162" onclick="location.href='index.cfm'">
				Message Manager
				</td>
				<td class="buttonbaract" width="105" onclick="location.href='../loginHome.cfm'">
				Back to NCSA
				</td>
				</CFOUTPUT>
				<td class="buttonbar"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"> </TD>
			</tr>
			</cfoutput>
		</table>
		</td>
	</tr>
	<tr>
		<td height="1" bgcolor="#454545"><IMG SRC="assets/images/spcrimg.gif" ALT="" WIDTH="1" HEIGHT="1"></td>
	</tr>
</table>
