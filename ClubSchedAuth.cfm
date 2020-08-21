<!--- 
	FileName:	ClubSchedAuth.cfm
	Created on: 12/03/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: Authorize Clubs to schedule games
	
MODS: mm/dd/yyyy - filastname - comments

 --->
 
<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm"> 

<cfoutput>
<div id="contentText">


<CFIF isDefined("FORM.bAddClub") OR isDefined("FORM.bAddAllClubs")>
	<!--- Authorize Clubs --->
	<CFIF isDefined("FORM.bAddAllClubs")>
		<CFSET listAuthClubs = 	FORM.listAllClubsToAdd>
	<CFELSE>
		<CFSET listAuthClubs = 	FORM.ADDCLUBIDS>
	</CFIF>
	<CFIF listLen(VARIABLES.listAuthClubs) GT 0>
		<CFQUERY name="qClubInfo" datasource="#SESSION.DSN#">
			UPDATE tbl_club
			   SET AllowSchedule_YN = 'Y'
			 WHERE club_id IN (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="Yes" value="#VARIABLES.listAuthClubs#">)
		</CFQUERY>
	</CFIF>
</CFIF>

<CFIF isDefined("FORM.bRemoveClub") OR  isDefined("FORM.bRemoveAllClubs")>
	<!--- UNauthorize Clubs --->
	<CFIF isDefined("FORM.bRemoveAllClubs")>
		<CFSET listRemoveClubs = FORM.listAllClubsToRemove>
	<CFELSE>
		<CFSET listRemoveClubs = FORM.remClubIDs>
	</CFIF>
	<CFIF listLen(VARIABLES.listRemoveClubs) GT 0>
		<CFQUERY name="qClubInfo" datasource="#SESSION.DSN#">
			UPDATE tbl_club
			   SET AllowSchedule_YN = 'N'
			 WHERE club_id IN (<cfqueryparam cfsqltype="CF_SQL_INTEGER" list="Yes" value="#VARIABLES.listRemoveClubs#">)
		</CFQUERY>
	</CFIF>
</CFIF>


<CFQUERY name="qClubInfo" datasource="#SESSION.DSN#">
	SELECT club_id, Club_name, ClubAbbr, AllowSchedule_YN
	  FROM tbl_club
</CFQUERY>
<CFQUERY name="qAuthClubs" dbtype="query">
	SELECT * FROM qClubInfo WHERE AllowSchedule_YN = 'Y' ORDER BY Club_name
</CFQUERY>
<CFQUERY name="qOtherClubs" dbtype="query">
	SELECT * FROM qClubInfo WHERE AllowSchedule_YN <> 'Y' ORDER BY Club_name
</CFQUERY>

<H1 class="pageheading">NCSA - Authorize Clubs for Pre Season Scheduling</H1>
<form name="frmClubAuth" action="ClubSchedAuth.cfm" method="post">
	<input type="Hidden" name="listAllClubsToRemove" value="#VALUELIST(qAuthClubs.club_id)#">
	<input type="Hidden" name="listAllClubsToAdd" 	 value="#VALUELIST(qOtherClubs.club_id)#">
	<table cellspacing="0" cellpadding="5" align="left" border="0" width="99%"  >
		<tr class="tblHeading">
			<TD align="right">	&nbsp; </TD>
		</tr>
		<tr><td><span class="red">Hold the CTRL down to select muultiple fields.</span>
					<table cellspacing="0" cellpadding="0" align="left" border="0">
						<tr><td align="left" valign="top">
								<br>Clubs <b>Authorized</b> for Pre Season Scheduling
							</td>
							<td align="center" valign="top">
							</td>
							<td align="LEFT" valign="top">
								<br>Clubs <b>NOT</b> Authorized for Pre Season Scheduling
							</td>
						</tr>
						<tr><td align="left" valign="top">
								<select name="remClubIDs" size="25" multiple class="sizetext12" >
									<CFIF isDefined("qAuthClubs") AND qAuthClubs.RECORDCOUNT GT 0>
										<CFLOOP query="qAuthClubs">
											<option value="#CLUB_ID#" >#Club_NAME#</option>
										</CFLOOP>
									<CFELSE>
										<option value="0" ><B>No clubs are authorized
									</CFIF>
								</select>
							</td>
							<td align="center" valign="top">
								<br> <br> 
								&nbsp;Remove &nbsp; <br> <input type="submit" name="bRemoveClub" value="&nbsp; > &nbsp;">
								#RepeatString("<br>",3)#
								&nbsp;Add    &nbsp; <br> <input type="submit" name="bAddClub"    value="&nbsp; < &nbsp;">
								#RepeatString("<br>",9)#
								&nbsp;Remove ALL&nbsp; <br> <input type="submit" name="bRemoveAllClubs" value=">>>">
								#RepeatString("<br>",3)#
								&nbsp;Add ALL  &nbsp;	<br> <input type="submit" name="bAddAllClubs"    value="<<<">
							</td>
							<td align="right" valign="top">
								<select name="addClubIDs" size="25" multiple class="sizetext12">
									<CFIF isDefined("qOtherClubs") AND qOtherClubs.RECORDCOUNT GT 0>
										<CFLOOP query="qOtherClubs">
											<option value="#CLUB_ID#" >#CLUB_NAME#</option>
										</CFLOOP>
									<CFELSE>
										<option value="0" >All the Clubs are authorized 
									</CFIF>
								</select>
							</td>
						</tr>
					</table>	
				</td>
			</tr>
	
	</table>	

</form>


</cfoutput>
</div>
<cfinclude template="_footer.cfm">
