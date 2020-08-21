<!--- 
	FileName:	clubContactDetails.cfm
	Created on: 08/07/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: this file will display a list of clubs and their reps
	
MODS: mm/dd/yyyy - filastname - comments

 --->

<cfset mid = 2>
<cfinclude template="_header.cfm">

<div id="contentText">
<cfoutput>
<cfif isdefined("url.cid")>
	<cfset clubID = url.cid>

	
	<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="clubInfo">
		<cfinvokeargument name="DSN"     value="#SESSION.DSN#">
		<cfinvokeargument name="clubID"  value="#clubID#">
		<cfinvokeargument name="orderby" value="clubname">
	</cfinvoke>  <!--- <cfdump var="#clubInfo#"> --->
	
	
	<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubReps" returnvariable="qClupReps">
		<!--- <cfinvokeargument name="DSN" value="#SESSION.DSN#"> --->
		<cfinvokeargument name="clubID" value="#clubID#">
	</cfinvoke>  <!--- <cfdump var="#boardMems#"> --->

	<table width="100%" border="0" cellpadding="5" cellspacing="0">
		<tr class="tblHeading">
			<td colspan="4" align="left">
				Club Information:
			</td>
		</tr>
		<tr><td width="15%" align="right" valign="top"><B>Club Name:</B>	
			<td colspan="3" valign="top">
				<B>#clubInfo.CLUB_NAME#</B>
			</td>
		</tr>
		<tr><td align="right" valign="top"><B>Address:</B>	
			</td>
			<TD>#clubInfo.ADDRESS#
				<BR>#clubInfo.CITY# #clubInfo.STATE# #clubInfo.ZIP#
			</TD>
			<td align="center" valign="bottom">Home Colors
			</td>
			<td align="center" valign="bottom">Away Colors
			</td>
		</tr>
		<tr><td align="right"><B>eMail:</B>	
			</td>
			<TD><CFIF len(trim(clubInfo.CLUBEMAIL))>
					<a href="mailto:#clubInfo.CLUBEMAIL#">#clubInfo.CLUBEMAIL#</a>
				<CFELSE>
					n/a
				</CFIF>
			</TD>
			<td align="center" valign="bottom">Shirt: #clubInfo.HOMESHIRTCOLOR#<!--- home --->
			</td>
			<td align="center" valign="bottom">Shirt: #clubInfo.AWAYSHIRTCOLOR #<!--- away --->
			</td>
		</tr>
		<tr><td align="right"><B>Club HomePage:</B>	
			</td>
			<TD><CFIF len(trim(clubInfo.ClubHomePage))>
					<A href="http://#clubInfo.ClubHomePage#" Target="_blank">#clubInfo.ClubHomePage#</A>
				<CFELSE>
					n/a
				</CFIF>
			</TD>
			<td align="center" valign="bottom">Shorts: #clubInfo.HOMESHORTCOLOR#<!--- home --->
			</td>
			<td align="center" valign="bottom">Shorts: #clubInfo.AWAYSHORTCOLOR#<!--- away --->
			</td>
		</tr>
	</table>
<!--- ==================================== --->
	<table width="100%" border="0" cellpadding="5" cellspacing="0">
		<tr class="tblHeading">
			<td colspan="3" align="left">
				Club Representatives:
			</td>
		</tr>
		<tr valign="top"  bgcolor="###setRowColor(SESSION.sitevars.altColors,1)#">
			<td width="33%" class="tdUnderLine">
				<B>Club President</B>: #qClupReps.PRES_Firstname# #qClupReps.PRES_lastName# 
				<br>
				<br><b>Email:</b> #qClupReps.PRES_Email#
			</td>
			<td width="33%" class="tdUnderLine">
				<b>Address:</b> 
					<BR>#repeatString("&nbsp;",5)# #qClupReps.PRES_Address# 
					<BR>#repeatString("&nbsp;",5)# #qClupReps.PRES_city# #qClupReps.PRES_State# #qClupReps.PRES_ZipCode#
				
			</td>
			<td width="33%" class="tdUnderLine">
				<table>
					<tr><td align="right"><b>Home:</b> </td><td> #qClupReps.PRES_PhoneHome# </td></tr>
				    <tr><td align="right"><b>fax: </b> </td><td> #qClupReps.PRES_PhoneFax#  </td></tr>
				    <tr><td align="right"><b>cell:</b> </td><td> #qClupReps.PRES_PhoneCell# </td></tr>
				    <tr><td align="right"><b>work:</b> </td><td> #qClupReps.PRES_PhoneWork# </td></tr>
				</table>
			</td>
		</tr>
		<tr valign="top"  bgcolor="###setRowColor(SESSION.sitevars.altColors,2)#">
			<td class="tdUnderLine">
				<b>Representative:</b> #qClupReps.REP_Firstname# #qClupReps.REP_lastName#
				<br>
				<br><b>Email:</b> #qClupReps.REP_Email#
			</td>
			<td class="tdUnderLine">
				<b>Address:</b> 
					<BR>#repeatString("&nbsp;",5)# #qClupReps.REP_Address# 
					<BR>#repeatString("&nbsp;",5)# #qClupReps.REP_city# #qClupReps.REP_State# #qClupReps.REP_ZipCode#
			</td>
			<td class="tdUnderLine">
				<table>
					<tr><td align="right"><b>Home:</b> </td><td> #qClupReps.REP_PhoneHome#  </td></tr>
					<tr><td align="right"><b>fax: </b> </td><td> #qClupReps.REP_PhoneFax#  </td></tr> 
					<tr><td align="right"><b>cell:</b> </td><td> #qClupReps.REP_PhoneCell#  </td></tr>
					<tr><td align="right"><b>work:</b> </td><td> #qClupReps.REP_PhoneWork# </td></tr>
				</table>
			</td>
		</tr>
		<tr valign="top" bgcolor="###setRowColor(SESSION.sitevars.altColors,3)#">
			<td class="tdUnderLine">
				<b>Alternate:</b> #qClupReps.ALT_Firstname# #qClupReps.ALT_lastName#
				<br>
				<br><b>Email:</b> #qClupReps.ALT_Email#
			</td>
			<td class="tdUnderLine">
				<b>Address:</b> 
					<BR>#repeatString("&nbsp;",5)# #qClupReps.ALT_Address# 
					<BR>#repeatString("&nbsp;",5)# #qClupReps.ALT_city# #qClupReps.ALT_State# #qClupReps.ALT_ZipCode#
			</td>
			<td class="tdUnderLine">
				<table>
					<tr><td align="right"><b>Home:</b> </td><td> #qClupReps.ALT_PhoneHome#  </td></tr>
					<tr><td align="right"><b>fax: </b> </td><td> #qClupReps.ALT_PhoneFax#  </td></tr>
					<tr><td align="right"><b>cell:</b> </td><td> #qClupReps.ALT_PhoneCell#  </td></tr>
					<tr><td align="right"><b>work:</b> </td><td> #qClupReps.ALT_PhoneWork# </td></tr>
				</table>
			</td>
		</tr>
	</table>
<cfelse>
    No input
</cfif>

</cfoutput>
</div>

<div align="center"> 
	<INPUT type="Button" name="goback" value="<< Back" onclick="history.go(-1)">
	<!--- <a href="" onclick="history.go(-1)"><< Back</a>  NFG, goes back to original page--->
</div> 

<cfinclude template="_footer.cfm">



