	<cfif isDefined("URL.clubID")>
		<cfset clubID = URL.clubID>
	<cfelse>
		<cfset clubID = "">
	</cfif>	

	<cfif isDefined("URL.TeamAge")>
		<cfset teamAge = URL.TeamAge>
	<cfelse>
		<cfset teamAge = "">
	</cfif>	

	<cfif isDefined("URL.Gender")>
		<cfset gender = URL.Gender>
	<cfelse>
		<cfset gender = "">
	</cfif>

	<cfif isDefined("URL.Roster")>
		<cfset roster = URL.Roster>
	<cfelse>
		<cfset roster = "">
	</cfif>	

	<cfif isDefined("URL.PrevPlayLevel")>
		<cfset prevPlayLevel = URL.PrevPlayLevel>
	<cfelse>
		<cfset prevPlayLevel = "">
	</cfif>

	<cfif isDefined("URL.TeamFormed")>
		<cfset teamFormed = URL.TeamFormed>
	<cfelse>
		<cfset teamFormed = "">
	</cfif>	

	<cfif isDefined("URL.TeamAvailability")>
		<cfset teamAvailability = URL.TeamAvailability>
	<cfelse>
		<cfset teamAvailability = "">
	</cfif>	

<cfoutput>
	<CFQUERY name="registeredTeams" datasource="#SESSION.DSN#">
		SELECT  CL.ClubAbbr, CL.club_id, CL.Club_name,
			   IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION, 
			   T.team_id, T.ContactIDHead, T.ContactIDAsst, T.club_id, T.teamName,
			   CL.ClubAbbr + '-' + IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'')+ '-' + HC.LastName AS TEAMNAMEderived, 
			   T.teamAge, T.playLevel, T.gender, T.requestDiv, T.comments, T.USSFDiv, T.season_id, T.suffix, 
			   T.teamstatus, T.nonSundayplay, T.playgroup, T.appeals, T.appealsStatus, T.standingFactor, 
			   T.approved_yn, T.registered_YN,
			   HC.FirstName AS coachFirstName,  HC.LastName AS coachLastName, 
			   HC.address   AS coachAddress,    HC.city AS coachTown,  HC.state AS coachState, HC.zipcode AS coachZip, 
			   HC.phoneWork AS coachWorkPhone, 	HC.phoneHome AS coachHomePhone, 
			   HC.phoneCell AS coachCellPhone,  HC.phoneFax AS coachFax, HC.email AS coachEmail,
		      (SELECT top 1 ci.secondTeam_id
				   FROM TBL_COACH_INFO ci 
						INNER JOIN XREF_CONTACT_ROLE xcr ON xcr.xref_contact_role_id = ci.xref_contact_role_id 
				  WHERE xcr.CONTACT_ID = T.contactIDHead
				      AND xcr.role_id = 29)  as secondTeam ,
			  (SELECT top 1 ci.coaching_program
				   FROM TBL_COACH_INFO ci 
						INNER JOIN XREF_CONTACT_ROLE xcr ON xcr.xref_contact_role_id = ci.xref_contact_role_id 
				  WHERE xcr.CONTACT_ID = T.contactIDHead
				      AND xcr.role_id = 29)  as coachingPgm ,
		
			   AC.FirstName AS asstCoachFirstName,  AC.LastName AS asstCoachLastName, 
			   AC.address 	AS asstAddress,   	    AC.city AS asstTown, AC.state AS asstState, AC.zipcode AS asstZip, 
			   AC.phoneWork	AS asstWorkPhone,		AC.phoneHome AS asstHomePhone, 
			   AC.phoneCell AS asstCellPhone,		AC.phoneFax AS asstFax, AC.email AS asstEmail,
			   T.roster as roster,
			   T.prevPlayLevel as prevPlayLevel,
			   T.reasonForPlayLevel as reasonForPlayLevel,
			   T.teamFormed as teamFormed,
			   T.teamAvailability as teamAvailability,
			   T.soccerID as soccerID
			
		FROM    tbl_team T  LEFT JOIN tbl_contact HC ON HC.contact_id = T.ContactIDHead 
							LEFT JOIN tbl_contact AC ON AC.contact_id = T.ContactIDAsst 
						   INNER JOIN tbl_club    CL ON CL.club_id    = T.club_id
		WHERE T.season_id = (select season_id from tbl_season where RegistrationOpen_YN = 'Y')
		<CFIF len(trim(clubID)) AND clubID NEQ 0>
			AND CL.club_id = <cfqueryParam cfsqltype="CF_SQL_NUMERIC" value="#clubID#">
		</CFIF>
		<CFIF len(trim(teamAge))>
			AND T.teamAge = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#teamAge#">
		</CFIF>
		<CFIF len(trim(gender))>
			AND T.gender = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#gender#">
		</CFIF>
		<CFIF len(trim(roster))>
			AND T.roster = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#roster#">
		</CFIF>
		<CFIF len(trim(prevPlayLevel))>
			AND T.prevPlayLevel = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#prevPlayLevel#">
		</CFIF>
		<CFIF len(trim(teamFormed))>
			AND T.teamFormed = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#teamFormed#">
		</CFIF>
		<CFIF len(trim(teamAvailability))>
			AND T.teamAvailability = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#teamAvailability#">
		</CFIF>
	</CFQUERY>	
</cfoutput>

<!--------------------------- 
	START PDF PAGE 
----------------------------->
<cfdocument 
	format="pdf" 
	marginBottom=".4"
	marginLeft=".3"
	marginRight=".3"
	marginTop=".75"  
	orientation="landscape" >
<!doctype html>
<html>
	<head>
		<title>NCSA - Team Registration information</title>
		<style type="text/css">
			#teamResultsTable {
				border-width: 1px 0 0 1px;
				border-style: solid;
				border-color: #ccc;
			}
			#teamResultsTable th,
			#teamResultsTable td {
				border-width: 0 1px 1px 0;
				border-style: solid;
				border-color: #ccc;
			}
		</style>
	</head>
<body>
<H1 class="pageheading">NCSA - Team Registration information</H1>

<div id="teamRegInfoResults">
	<table width="1700" border="0" cellspacing="0" cellpadding="3" align="center" border="0" width="100%" id="teamResultsTable" class="tablesorter" style="table-layout:fixed;">
		<thead>
			<tr class="tblHeading">
				<th width="50" align="center">Gender</th>
				<th width="50" align="center">Age</th>
				<th width="50" align="center">Level</th>
				<th width="50" align="center">Group</th>
				<th width="50" align="center">Req. Div</th>
				<th width="50" align="center">USSF Div</th>
				<th width="250" align="center">Team Name</th>
				<th width="100" align="center">Phone</th>
				<th width="300" align="center">Appeal</th>
				<th width="50" align="center">Status</th>
				<th width="50" align="center">Roster</th>
				<th width="150" align="center">Team Formed</th>
				<th width="50" align="center">Team Avail.</th>
				<th width="150" align="center">Soccer ID</th>
				<th width="75" align="center">Prev Play Lvl</th>
				<th width="300" align="center">Reason for Play Lvl</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="registeredTeams">	
				<cfoutput>
				<tr>
					<td width="50" align="center">#gender#</td>
					<td width="50" align="center">#teamAge#</td>
					<td width="50" align="center">#playlevel#</td>
					<td width="50" align="center">#playgroup#</td>
					<td width="50" align="center">#requestdiv#</td>
					<td width="50" align="center">#ussfdiv#</td>
					<td width="250" align="center">#teamname#</td>
					<td width="100" align="center">#coachhomephone#</td>
					<td width="300" align="left">#appeals#</td>
					<td width="50" align="center">#appealsstatus#</td>
					<td width="50" align="center">#roster#</td>
					<td width="150" align="center">#teamFormed#</td>
					<td width="50" align="center">#teamAvailability#</td>
					<td width="150" align="center">#soccerID#</td>
					<td width="75" align="center">#prevPlayLevel#</td>
					<td width="300" align="left">#reasonForPlayLevel#</td>
				</tr>
				</cfoutput>
			</cfloop>
		</tbody>
	</table>
</div>
</body>
</html>
</cfdocument>