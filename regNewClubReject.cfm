<!--- 
	FileName:	regNewClubDetail.cfm
	Created on: 09/05/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: displays club details of a newly requested club
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<CFSET errMsg = "">


<CFIF isDefined("URL.ID") and isNumeric(URL.ID)>
	<CFSET ClubApplID = URL.ID>
<CFELSEIF isDefined("FORM.ClubApplID") and isNumeric(FORM.ClubApplID)>
	<CFSET ClubApplID = FORM.ClubApplID>
</CFIF>


<!--- GET CLUB INFO --->
<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="ClubRequestDetails" returnvariable="regDetails">
	<cfinvokeargument name="newClubID" value="#VARIABLES.ClubApplID#">
</cfinvoke>  
<CFSET ClubDetails = regDetails.club>
<CFSET TeamDetails = regDetails.team>


<cfoutput>
<div id="contentText">
<H1 class="pageheading">NCSA - New Club REJECT</H1>
<h2>Club: #ClubDetails.club# </h2> 
<br>	
<span class="red">Are you sure you want to REJECT this application?</span>

<CFIF isDefined("FORM.CANCEL")>
	<cflocation url="regAppNewClub.cfm">
</CFIF>

<CFIF isDefined("FORM.REJECT")>
	<!--- Update the comments with most recent comments from this page. --->
	<cfinvoke component="#SESSION.sitevars.cfcPath#registration" method="updateClubComments" returnvariable="testingout">
		<cfinvokeargument name="ClubID" value="#FORM.CLUBAPPLID#">
		<cfinvokeargument name="Comment" value="#FORM.COMMENTS#">
	</cfinvoke>  
	<!--- Update ClubRegRequest Table --->
	<CFQUERY name="qUpdClubRegReq" datasource="#SESSION.DSN#">
		UPDATE TBL_ClubRegRequest
		   SET status = 'R'
		     , updateDate = getDate()
			 , updatedBy  = #SESSION.USER.CONTACTID#
		 WHERE ID = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="#VARIABLES.ClubApplID#">
	</CFQUERY>
	<cflocation url="regAppNewClub.cfm">
</CFIF>


	
<form action="regNewClubReject.cfm" method="post">
	<input type="Hidden" name="ClubApplID"		value="#VARIABLES.ClubApplID#">

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
				<span class="red">Are you sure you want to REJECT this application?</span>
				<br>
				<INPUT type="submit" name="cancel" value="Cancel" >
				&nbsp; &nbsp;
				<cfif SESSION.MENUROLEID EQ 1>
					<INPUT type="submit" name="reject"  value="Reject">
				</cfif>
			</TD>
		</tr>
	</TABLE>
</FORM>
	 
</cfoutput>
</div>
<cfinclude template="_footer.cfm">


