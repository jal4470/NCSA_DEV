<!--- 
	FileName:	rptTeamRegInfo.cfm
	Created on: 07/12/2016
	Created by: rgonzalez@capturepoint.com
	
	Purpose: 
	
MODS: mm/dd/yyyy - filastname - comments

05/22/2017 - apinzone - removed jquery 1.4.2, moved javascript to bottom of page and wrapped in cfsavecontent

 --->
 
<cfinclude template="_header.cfm">

<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css"> 	
</cfsavecontent>
<cfhtmlhead text="#jqueryUI_CSS#">

<cfif isDefined("FORM.club_id")>
	<cfset clubID = FORM.club_id>
<cfelse>
	<cfset clubID = "">
</cfif>	

<cfif isDefined("FORM.TeamAge")>
	<cfset teamAge = FORM.TeamAge>
<cfelse>
	<cfset teamAge = "">
</cfif>	

<cfif isDefined("FORM.Gender")>
	<cfset gender = FORM.Gender>
<cfelse>
	<cfset gender = "">
</cfif>

<cfif isDefined("FORM.Roster")>
	<cfset roster = FORM.Roster>
<cfelse>
	<cfset roster = "">
</cfif>	

<cfif isDefined("FORM.PrevPlayLevel")>
	<cfset prevPlayLevel = FORM.PrevPlayLevel>
<cfelse>
	<cfset prevPlayLevel = "">
</cfif>

<cfif isDefined("FORM.TeamFormed")>
	<cfset teamFormed = FORM.TeamFormed>
<cfelse>
	<cfset teamFormed = "">
</cfif>	

<cfif isDefined("FORM.TeamAvailability")>
	<cfset teamAvailability = FORM.TeamAvailability>
<cfelse>
	<cfset teamAvailability = "">
</cfif>	

<cfoutput>
<div id="contentText">

<!--- WE are not using SESSION values because it is a public page  --->
<!--- <cfset seasonID = 0>	
<cfset seasonSF = "">
<cfset seasonYR = "">

<cfset seasonID=session.regseason.id>
<cfset seasonSF=session.regseason.sf>
<cfset seasonYR=session.regseason.year> --->

<!--- Get Club name list --->
<cfinvoke component="#SESSION.SITEVARS.cfcPath#registration" method="getRegisteredClubs" returnvariable="qClubs">
		<cfinvokeargument name="orderby" value="clubname">
</cfinvoke>

<!--- Get Team Age --->
<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lTeamAges">
	<cfinvokeargument name="listType" value="TEAMAGES"> 
</cfinvoke>

<CFINVOKE component="#SESSION.SITEVARS.cfcPath#team" method="getPreviousSeasonDivisions" returnvariable="lDivision"> <!--- Divisions --->


<H1 class="pageheading">NCSA - Team Registration information <!--- #pageTitle# ---></H1>
<!--- <h2>For #VARIABLES.seasonSF# #VARIABLES.seasonYR# Teams </h2> --->


<FORM id="teamRegInfo" action="rptTeamRegInfo.cfm" method="post">

	<div id="qClubs" class="question">
		<label for="clubs" style="display: block;"><b>Select a Club:</b></label>
		<SELECT name="club_id" id="club_id">
			<option value="0">All Clubs</option>
			<cfloop query="qClubs">
				<option value="#CLUB_ID#" <CFIF CLUB_ID EQ ClubID>selected</CFIF> >#CLUB_NAME#</option>
			</cfloop>
		</SELECT>
	</div>
	<div id="qTeamAge" class="question">
		<label for="teamAge" style="display: block;"><b>Team Age</b></label>
		<SELECT name="teamAge" id="teamAge"> 
			<OPTION value="" selected>All Ages</OPTION>
			<CFLOOP list="#lTeamAges#" index="ita">
				<OPTION value="#ita#" <CFIF teamAge EQ ita>selected</CFIF>  >#ita#</OPTION>
			</CFLOOP>
		</SELECT>
	</div>
	<div id="qGender" class="question">
		<label for="gender" style="display: block;"><b>Select Gender </b></label>
		<SELECT name="gender" id="gender">
			<OPTION value=""  <cfif gender EQ "">selected</cfif> > Both </OPTION>
			<OPTION value="B" <cfif gender EQ "B">selected</cfif> > Boys </OPTION>
			<OPTION value="G" <cfif gender EQ "G">selected</cfif> > Girls</OPTION>
		</SELECT>
	</div>
	<div id="qRoster" class="question">
		<label for="roster" style="display: block;"><b>Team Roster Question</b></label>
		<SELECT name="roster" id="roster">
			<OPTION value="">Select</OPTION>
			<OPTION value="yes" <CFIF roster EQ "yes">selected</CFIF> >Yes</OPTION>
			<OPTION value="no" <CFIF roster EQ "no">selected</CFIF> >No</OPTION>
		</SELECT>
	</div>
	<div id="qPrevPlayLevel" class="question" style="display:none;">
		<label for="prevPlayLevel" style="display: block;"><b>Flight Previously Played Question</b></label>
		<SELECT name="prevPlayLevel" id="prevPlayLevel">
			<OPTION value="" >Select</OPTION>
			<CFLOOP list="#ValueList(lDivision.division,",")#" index="div">
				<cfif FindNoCase('X', div) eq 0 AND FindNoCase('R', div) eq 0>
					<OPTION value="#div#" <CFIF prevPlayLevel EQ div>selected</CFIF> >#div#</OPTION>
				</cfif>
			</CFLOOP>
		</SELECT>
	</div>
	<div id="qTeamFormed" class="question">
		<label for="teamFormed" style="display: block;"><b>Team Formation Question</b></label>
		<SELECT name="teamFormed" id="teamFormed">
			<OPTION value="" selected>Select</OPTION>
			<OPTION value="using birth year" <CFIF teamFormed EQ "using birth year">selected</CFIF> >Using birth year only to form team</OPTION>
			<OPTION value="using old 7/31-8/1 year" <CFIF teamFormed EQ "using old 7/31-8/1 year">selected</CFIF> >Using old 7/31-8/1 year (playing up)</OPTION>
			<OPTION value="other" <CFIF teamFormed EQ "other">selected</CFIF> >Other-Does not fit either of above</OPTION>
		</SELECT>
	</div>
	<div id="qTeamAvailability" class="question">
		<label for="teamAvailability" style="display: block;"><b>Team Availability Question</b></label>
		<SELECT name="teamAvailability" id="teamAvailability">
			<OPTION value="">Select</OPTION>
			<OPTION value="yes" <CFIF teamAvailability EQ "yes">selected</CFIF> >Yes</OPTION>
			<OPTION value="no" <CFIF teamAvailability EQ "no">selected</CFIF> >No</OPTION>
		</SELECT>
	</div>

	<div id="qSubmit" class="question-submit">
		<input type="Submit" name="GETTEAM" value="Get Team">
		<input type="Submit" name="printme" value="Printer Friendly" style="float:right;">  
	</div>

</FORM>

<br>
<CFIF isDefined("FORM.GETTEAM")>
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
			</cfloop>
		</tbody>
	</table>
</div>

<CFELSEIF isDefined("FORM.PRINTME")>

	<!--- This will pop up a window that will display the page in a pdf --->
	<cfset qString = "clubID=#club_id#&teamAge=#TeamAge#&gender=#Gender#&roster=#Roster#&prevPlayLevel=#PrevPlayLevel#&teamFormed=#TeamFormed#&teamAvailability=#TeamAvailability#">
	<script> window.open('rptTeamRegInfo_PDF.cfm?#qString#','popwin'); </script> 

</CFIF>

</cfoutput>
</div>

<!--- JQuery and Tablesorter --->
<cfsavecontent variable="cf_footer_scripts">
	<script language="JavaScript" type="text/javascript" src="assets/jquery-ui-1.12.1.min.js"></script>
	<script language="JavaScript" type="text/javascript" src="assets/jquery.tablesorter.min.js"></script>
	<!--- CUSTOM JAVASCRIPT --->
	<script type="text/javascript">
		$(document).ready(function(){

			if ($('#roster').val() == 'yes'){
				$('#qPrevPlayLevel').show();
			} else {
				$('#qPrevPlayLevel').hide();
				$('#prevPlayLevel').val('');
			}

			$('#roster').change(function(){
				if ($(this).val() == 'yes'){
					$('#qPrevPlayLevel').show();
				} else {
					$('#qPrevPlayLevel').hide();
					$('#prevPlayLevel').val('');
				}
			});

			// Tablesorter
			$('#teamResultsTable').tablesorter();

		}); // document ready
	</script>
</cfsavecontent>

<cfinclude template="_footer.cfm">
