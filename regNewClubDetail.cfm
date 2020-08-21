<!--- 
	FileName:	regNewClubDetail.cfm
	Created on: 09/05/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: displays club details of a newly requested club
	
MODS: mm/dd/yyyy - filastname - comments
07/18/2016 - R. Gonzalez - Added extra hidden input to force a comment update on next page
 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<CFSET errMsg = "">

<cfif isDefined("URL.ID") AND isNumeric(URL.ID)>
	<cfset clubAppID = URL.ID >
	<cfset swShowButtons = true>
<cfelseif isDefined("URL.HID") AND isNumeric(URL.HID)>
	<cfset clubAppID = URL.HID >
	<cfset swShowButtons = false>
<cfelse>
	<cfset clubAppID = 0 >
	<cfset swShowButtons = false>
</cfif>


<!--- GET CLUB INFO --->
<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="ClubRequestDetails" returnvariable="regDetails">
	<cfinvokeargument name="newClubID" value="#VARIABLES.clubAppID#">
</cfinvoke>  

<CFSET ClubDetails = regDetails.club>
<CFSET TeamDetails = regDetails.team>

<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - New Club Details</H1>
<br>
<h2>Club: #ClubDetails.club# </h2>
<br>	

	
<form action="regNewClubApprove.cfm" method="post">
	<input type="Hidden" name="clubID"		value="#VARIABLES.clubAppID#">
	<input type="Hidden" name="clubName"	value="#ClubDetails.club#">
	<input type="Hidden" name="presFname"	value="#ClubDetails.PresidentName#">
	<input type="Hidden" name="presLname"	value="#ClubDetails.PresidentLastname#">
	<input type="Hidden" name="homePhone"	value="#ClubDetails.PHomePhone#">
	<input type="Hidden" name="cellPhone"	value="#ClubDetails.PCellPhone#">
	<input type="Hidden" name="Fax"			value="#ClubDetails.PFax#">
	<input type="Hidden" name="workPhone"	value="#ClubDetails.PPhone#">
	<input type="Hidden" name="email"		value="#ClubDetails.PEmail#">
	<input type="Hidden" name="presAddress" value="#ClubDetails.PAddress#">
	<input type="Hidden" name="presTown"	value="#ClubDetails.PTown#">
	<input type="Hidden" name="presState"	value="#ClubDetails.Pstate#">
	<input type="Hidden" name="presZip"		value="#ClubDetails.PZip#">
	<input type="Hidden" name="updComment"	value="1">
			
	<TABLE  cellSpacing=0 cellPadding=3 width="85%" border=0>
		<!--- ====================================================================== --->
		<tr class="tblHeading">
			<td colspan="2"> &nbsp; Club Info:</td>
		</tr>
		<TR><td width="18%" align="right"> <b>Information Date</b>	</TD>
			<td >#DateFormat(ClubDetails.RequestDate,"MM/DD/YYYY")# 			</TD>
		</TR>
		<TR><td align="right">  <b>Club Name: </b>			</TD>
			<td>#ClubDetails.club#</TD>
		</TR>
		<TR><td align="right" valign="top"> <b>Club Address: </b>					</TD>
			<td>#ClubDetails.Address#
				<br>#ClubDetails.Town#  #ClubDetails.State#, #ClubDetails.Zip#
			</TD>
		</TR>
		<!--- ====================================================================== --->
		<tr class="tblHeading">
			<td colspan="2"> &nbsp; President Info:</td>
		</tr>
		<TR><td width="18%" align="right"> <b>Name: </b>	</TD>
			<td >#ClubDetails.PresidentName#  #ClubDetails.PresidentLastname#</TD>
		</TR>
		<TR><td align="right" valign="top"> <b>Address: </b>		</TD>
			<td > #ClubDetails.PAddress# 
				<br> #ClubDetails.PTown# #ClubDetails.Pstate#, #ClubDetails.PZip#
			</TD>
		</TR>
		<tr><td align="right" valign="top"> <b>Phone ##s: </b>		</TD>
			<td>
				<table>
					<TR><td align="right"> <b>Home: </b></TD>
						<td>#ClubDetails.PHomePhone#</TD>
						<td align="right"> <b>Cell: </b>		</TD>
						<td >#ClubDetails.PCellPhone#			</TD>
					</TR>
					<TR><td align="right"><b>Fax</b>:</b>	</TD>
						<td >#ClubDetails.PFax#			</TD>
						<td align="right"><b>Work: </b> </td>
						<td>	#ClubDetails.PPhone#			</TD>
					</TR>
				</table>
			
			</td>
		</tr>
		<TR><td align="right">  <b>EMail:</b>		</TD>
			<td > #ClubDetails.PEmail# </TD>
		</TR>
		<!--- ====================================================================== --->
		<tr class="tblHeading">
			<td colspan="2"> &nbsp; Field/Team Info:</td>
		</TR>
		<TR><td colspan="2">
				<table>
					<tr><td align="right">  <b>USSF Certified Referees:</b> </TD>
						<td > #ClubDetails.USSFCertReferees# </TD>
					</tr>
					<tr><td align="right">  <b>Home Fields:</TD>
						<td>&nbsp;Full Sided:  #ClubDetails.HomeFieldFull# 
							&nbsp;&nbsp;&nbsp;
							&nbsp;Small Sided: #ClubDetails.HomeFieldSmall# 
						</TD>
					</tr>
				</table>
			</td>  
		</TR>
		<!--- ====================================================================== --->
		<!--- <tr><td colspan="2" >
				&nbsp;
			</td>
		</tr> --->
		<tr><td class="tdUnderLine" colspan="2" >
				<table cellSpacing=0 cellPadding=0 border=1 align="center" width="100%">
				<cfset lAges = "U07,U08,U09,U10,U11,U12,U13,U14,U15,U16,U17,U18">
				<TR class="tblHeading">
					<td align="right"> &nbsp;</td>
					<cfloop list="#lAges#" index="iAge">
						<td align="center"> #iAge#</td>
					</cfloop>
				</tr>
				<tr><td align="right">## Boys teams &nbsp; </td>
					<cfloop list="#lAges#" index="iAge">
						<cfquery name="qCT" dbtype="query">
							select teamsCount from teamDetails where GENDER = 'B' and TEAMAGE = '#iAge#'
						</cfquery>
						<td align="center"> #qCT.teamsCount# &nbsp;</td>
					</cfloop>
				</tr>
				<tr><td align="right">Boys Level &nbsp; </td>
					<cfloop list="#lAges#" index="iAge">
						<cfquery name="qCT" dbtype="query">
							select PLAYLEVEL from teamDetails where GENDER = 'B' and TEAMAGE = '#iAge#'
						</cfquery>
						<td align="center"> #qCT.PLAYLEVEL# &nbsp;</td>
					</cfloop>
				</tr>
				<tr><td align="right">## Girls teams &nbsp; </td>
					<cfloop list="#lAges#" index="iAge">
						<cfquery name="qCT" dbtype="query">
							select teamsCount from teamDetails where GENDER = 'G' and TEAMAGE = '#iAge#'
						</cfquery>
						<td align="center"> #qCT.teamsCount# &nbsp;</td>
					</cfloop>
				</tr>
				<tr><td align="right">Girls Level &nbsp; </td>
					<cfloop list="#lAges#" index="iAge">
						<cfquery name="qCT" dbtype="query">
							select PLAYLEVEL from teamDetails where GENDER = 'G' and TEAMAGE = '#iAge#'
						</cfquery>
						<td align="center"> #qCT.PLAYLEVEL# &nbsp;</td>
					</cfloop>
				</tr>
				</table>
			</td>
		</tr>
		<!--- ====================================================================== --->
		<tr class="tblHeading">
			<td colspan="2" align="left"  >
				Comment/Resume/History
			</TD>
		</tr>
		<tr><td class="tdUnderLine" colspan="2" align="center"  > <!--- disabled --->
				<TEXTAREA name="Comments" rows=5 cols=75>#Trim(ClubDetails.Comments)#</TEXTAREA>
			</TD>
		</TR>
		<!--- ====================================================================== --->
		<tr><td colspan="2" align="center"  >
				<br>
				<INPUT type="Button" name="goback" value="<< Back" onclick="history.go(-1)">
				&nbsp; &nbsp;
				<cfif SESSION.MENUROLEID EQ 1>
					<INPUT type="submit" name="approve" value="Approve">
					<cfif swShowButtons>
						<INPUT type="submit" name="reject"  value="Reject">
						<INPUT type="submit" name="delete"  value="Delete">
					</cfif>
				</cfif>
			</TD>
		</tr>
	</TABLE>
</FORM>
	 
</cfoutput>
</div>
<cfinclude template="_footer.cfm">


