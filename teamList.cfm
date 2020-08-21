<!--- 
	FileName:	teamList.cfm
	Created on: 12/02/2008
	Created by: aarnone@capturepoint.com
	
	Purpose: this file will display a list of clubs and their reps
	
MODS: mm/dd/yyyy - filastname - comments
	01/09/09 - aarnone - added current season to display
 --->
<cfset mid = 0>
<cfinclude template="_header.cfm">
<div id="contentText">
<cfoutput>
<H1 class="pageheading"> NCSA Team List  for the <b>#SESSION.CURRENTSEASON.SF# #SESSION.CURRENTSEASON.YEAR#</b> season</H1>

<CFIF isDefined("url.CID") AND IsNumeric(url.cID)>
	<CFSET clubID = url.cID>
<CFELSEIF isDefined("FORM.clubID") AND FORM.clubID GT 0>
	<CFSET clubID = FORM.clubID>
<CFELSE>
	<CFSET clubID = 0>
</CFIF>

<CFIF listFind(SESSION.CONSTANT.CUROLES,SESSION.MENUROLEID) GT 0>
	<!--- we are logged in as "CU" as a CLUB user(rep,alt,pres) 
		  Make the selected club equal to the user's club	--->
	<CFSET clubID = SESSION.USER.CLUBID>
</CFIF> 


<CFIF listFind(SESSION.CONSTANT.CUroles,SESSION.menuRoleID) EQ 0>
	<!--- We are logged in as ADMIN (NOT CLUB USER) --->
	<cfinvoke component="#SESSION.sitevars.cfcPath#club" method="getClubInfo" returnvariable="clubInfo">
		<cfinvokeargument name="DSN"     value="#SESSION.DSN#">
		<cfinvokeargument name="orderby" value="clubname">
	</cfinvoke>  <!--- <cfdump var="#clubInfo#"> --->
		
	<FORM action="teamList.cfm" method="post">
		<select name="clubid">
			<option value="0">Select a Club...</option>
			<CFLOOP query="clubInfo">
				<option value="#CLUB_ID#" <cfif variables.clubid EQ CLUB_ID>selected</cfif> >#CLUB_NAME#</option>
			</CFLOOP>
		</select> 
		<input type="Submit" name="getTeams" value="Enter">
	</FORM>
</CFIF>  


<CFIF VARIABLES.clubid GT 0>
	<cfinvoke component="#SESSION.sitevars.cfcPath#team" method="getClubTeams" returnvariable="qClubTeams">
		<cfinvokeargument name="DSN"     value="#SESSION.DSN#">
		<cfinvokeargument name="clubID"  value="#VARIABLES.clubID#">
	</cfinvoke>  
	
	<table cellspacing="0" cellpadding="5" align="center" border="0" width="100%">
		<tr class="tblHeading">
			<td colspan="4"> #qClubTeams.Club_Name# </td>
		</tr>
		<tr class="tblHeading">
			<td> DIVISION   </td>
			<td> TEAM 		</td>
			<td> COACH 	    </td>
			<td> ASST COACH </td>
		</tr>
		<CFIF qClubTeams.recordCount>
			<CFLOOP query="qClubTeams">
				<tr bgcolor="###setRowColor(SESSION.sitevars.altColors,currentRow)#">
					<td valign="top" class="tdUnderLine">
						&nbsp; #DIVISION#
					</TD>
					<td valign="top" class="tdUnderLine">
						&nbsp; <a href="teamEdit.cfm?tid=#TEAM_ID#&cid=#CLUB_ID#">#TEAMNAMEDERIVED#</a>
					</TD>
					<td valign="top" class="tdUnderLine">
						&nbsp; #coachFirstName# #coachLastName#
					</TD>
					<td valign="top" class="tdUnderLine">
						&nbsp; #asstCoachFirstNAme# #asstCoachLastName#
					</td>
				</tr>
			</CFLOOP>
		<CFELSE>
			<tr><td colspan="4" align="center"> <br> <span class="red"><b>There are no teams for this club</b></span> </td>
			</tr>
		</CFIF>
	</table>
</CFIF>





</cfoutput>
</div>


<cfinclude template="_footer.cfm">



