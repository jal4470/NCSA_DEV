<cfset mid = 0> <!--- optional =menu id ---> 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">


<cfif isDefined("URL.clubId")>
	<cfset clubID = URL.clubId>
<cfelse>
	<cfset clubID = "0">
</cfif>	

<cfif isDefined("URL.TeamAge")>
	<cfset teamAge = URL.TeamAge>
<cfelse>
	<cfset teamAge = "">
</cfif>	

<cfif isDefined("URL.playLevel")>
	<cfset playLevel = URL.playLevel>
<cfelse>
	<cfset playLevel = "">
</cfif>	

<cfif isDefined("URL.Gender")>
	<cfset gender = URL.Gender>
<cfelse>
	<cfset gender = "">
</cfif>

<cfif isDefined("URL.Season")>
	<cfset Season = URL.Season>
<cfelse>
	<cfset Season = session.regseason.id>
</cfif>

<cfif isDefined("URL.SORT")>
	<cfset sort = URL.sort>
<cfelse>
	<cfset sort = "">
</cfif>

<cfif isDefined("URL.ORDER")>
	<cfset order = URL.order>
<cfelse>
	<cfset order = "">
</cfif>

<CFQUERY name="registeredTeams" datasource="#SESSION.DSN#">
		SELECT  CL.ClubAbbr, CL.club_id, CL.Club_name,
			   IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'') AS DIVISION, 
			   T.team_id, T.ContactIDHead, T.ContactIDAsst, T.club_id, T.teamName,
			   dbo.GetTeamName2(T.team_id) AS TEAMNAMEderived, 
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
			   T.soccerID as soccerID,
			   case when lg.prior_team_id = 0 then null else convert(varchar,lg.prior_team_id) end as prior_team_id, 
			   case when lg.prior_team_id = 0 then 'N/A' else dbo.GetTeamName2(lg.prior_team_id) end as prior_team_name, 
			   case when lg.prior_season_id is not null then
			   	(select SeasonCode from tbl_season where season_id = lg.prior_season_id) 
			   else
			   	'N/A'
			   end as prior_season
		FROM    tbl_team T  LEFT JOIN tbl_contact HC ON HC.contact_id = T.ContactIDHead 
							LEFT JOIN tbl_contact AC ON AC.contact_id = T.ContactIDAsst 
						   INNER JOIN tbl_club    CL ON CL.club_id    = T.club_id
						   INNER JOIN tbl_registration_team_log lg on lg.new_team_id = t.team_id
		WHERE 0=0
		<CFIF ClubId neq 0>
			AND CL.club_id = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#ClubId#">
		</CFIF>
		<CFIF len(trim(teamAge))>
			AND T.teamAge = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#teamAge#">
		</CFIF>
		<CFIF len(trim(gender))>
			AND T.gender = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#gender#">
		</CFIF>
		<CFIF len(trim(playLevel))>
			AND T.PlayLevel = <cfqueryParam cfsqltype="CF_SQL_VARCHAR" value="#playLevel#">
		</CFIF>
		<CFIF len(trim(Season))>
			AND T.season_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#season#">
		<CFELSE>
			AND T.season_id = (select season_id from tbl_season where RegistrationOpen_YN = 'Y')
		</CFIF>
		<CFIF LEN(TRIM(VARIABLES.ORDER))>
			order by <cfoutput>#variables.sort# #variables.order#</cfoutput>
		</CFIF>
	</CFQUERY>	

	<!--- <cfdump var="#registeredTeams#">
	<cfabort> --->
<!--------------------------- 
	START PDF PAGE 
----------------------------->
<cfdocument 
	format="pdf" 
	marginBottom=".4"
	marginLeft=".3"
	marginRight=".3"
	marginTop=".75"  
	orientation="landscape" localurl="true"
	name="output">
<html>
	<head>
		<title>NCSA - Log of Created Teams by Season</title>
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
<H1 class="pageheading">NCSA - Log of Created Teams by Season</H1>

<div id="teamRegInfoResults">
	<table width="1700" border="0" cellspacing="0" cellpadding="3" align="center" border="0" width="100%" id="teamResultsTable" class="tablesorter" style="table-layout:fixed;">
		<thead>
			<tr class="tblHeading">
				<th width="75" data-sort="prior_team_id" data-order="asc" align="center">Prior Season Team Id</th>
				<th width="75" data-sort="prior_team_name" data-order="asc" align="center">Prior Season Team Name</th>
				<th width="75" data-sort="team_id" data-order="asc" align="center">Registration Season Team Id</th>
				<th width="75" data-sort="teamname" data-order="asc" align="center">Registration Season Team Name</th>
				<th width="50" data-sort="teamAge" data-order="asc" align="center">Registration Season Age</th>
				<th width="50" data-sort="playlevel" data-order="asc" align="center">Registration Season Team Level</th>
				<th width="50" data-sort="gender" data-order="asc" align="center">Registration Season Gender</th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="registeredTeams">	
				<tr>
					<td width="75" align="center">#prior_team_id#</td>
					<td width="75" align="center">#prior_team_name#</td>
					<td width="250" align="center">#team_id#</td>
					<td width="250" align="center">#teamnamederived#</td>
					<td width="50" align="center">#teamAge#</td>
					<td width="50" align="center">#playlevel#</td>
					<td width="50" align="center">#gender#</td>
				</tr>
			</cfoutput>
		</tbody>
	</table>
</div>
</body>
</html>
</cfdocument>
<CFSET filename = "#SESSION.USER.CONTACTID#SeasonTeamLog.PDF" >
<cfheader name="Content-disposition" value="attachment;filename=#filename#"> 
<cfcontent type="application/vnd.Microsoft Excel Comma Seperated Values 
	File; charset=utf-8" variable="#ToBinary( ToBase64( output ) )#">