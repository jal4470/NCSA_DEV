<!--- 
	FileName:	rptTeamRegInfo.cfm
	Created on: 07/12/2016
	Created by: rgonzalez@capturepoint.com
	
	Purpose: 
	
MODS: mm/dd/yyyy - filastname - comments

05/22/2017 - apinzone - removed jquery 1.4.2, moved javascript to bottom of page and wrapped in cfsavecontent

 --->
 
<cfinclude template="_header.cfm">
<cfinclude template="_checkLogin.cfm">

<cfsavecontent variable="jqueryUI_CSS">
	<link rel="stylesheet" type="text/css" href="assets/themes/jquery-ui-1.12.1/jquery-ui-1.12.1.min.css"> 	
	<style>
		#teamRegInfoResults {
		    border: solid #ccc;
		    border-width: 1px;
		    overflow-x: hidden;
		    overflow-y: auto;
		    max-height: 400px;
		    width:100%;
		}
	</style>
</cfsavecontent>
<cfhtmlhead text="#jqueryUI_CSS#">

<cfif isDefined("FORM.club_id")>
	<cfset clubID = FORM.club_id>
<cfelse>
	<cfset clubID = "0">
</cfif>	

<cfif isDefined("FORM.TeamAge")>
	<cfset teamAge = FORM.TeamAge>
<cfelse>
	<cfset teamAge = "">
</cfif>	

<cfif isDefined("FORM.playLevel")>
	<cfset playLevel = FORM.playLevel>
<cfelse>
	<cfset playLevel = "">
</cfif>	

<cfif isDefined("FORM.Gender")>
	<cfset gender = FORM.Gender>
<cfelse>
	<cfset gender = "">
</cfif>

<cfif isDefined("FORM.Season")>
	<cfset Season = FORM.Season>
<cfelse>
	<cfif isdefined("session.regseason")>
		<cfset Season = session.regseason.id>
	<cfelse>
		<cfset Season = session.currentseason.id>
	</cfif>
</cfif>
<cfif isDefined("FORM.SORT")>
	<cfset sort = FORM.sort>
<cfelse>
	<cfset sort = "prior_team_id">
</cfif>

<cfif isDefined("FORM.ORDER")>
	<cfset order = FORM.order>
<cfelse>
	<cfset order = "asc">
</cfif>
<cfoutput>


<CFIF isDefined("FORM.PRINTME")>

	<!--- This will pop up a window that will display the page in a pdf --->
	<cfset qString = "clubID=#clubId#&teamAge=#teamAge#&playLevel=#playLevel#&gender=#gender#&Season=#Season#&sort=#sort#&order=#order#">
<!--- 	<script> window.location.href = 'rptTeamCreatedSeason_PDF.cfm?#qString#'; </script>  --->
	<cflocation url="rptTeamCreatedSeason_PDF.cfm?#qString#">
<CFELSEIF isDefined("FORM.EXPORT")>

	<!--- This will pop up a window that will display the page in a pdf --->
	<cfset qString = "clubID=#clubId#&teamAge=#teamAge#&playLevel=#playLevel#&gender=#gender#&Season=#Season#&sort=#sort#&order=#order#">
<!--- 	<script> window.location.href = 'rptTeamCreatedSeason_csv.cfm?#qString#'; </script>  --->
	<cflocation url="rptTeamCreatedSeason_csv.cfm?#qString#">
</CFIF>


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

<cfinvoke component="#SESSION.SITEVARS.cfcpath#globalVars" method="getListX" returnvariable="lPlayLevel">
	<cfinvokeargument name="listType" value="PLAYLEVEL"> 
</cfinvoke>
<CFINVOKE component="#SESSION.SITEVARS.cfcPath#team" method="getPreviousSeasonDivisions" returnvariable="lDivision"> <!--- Divisions --->

<cfquery name="getSeasons" datasource="#session.dsn#">
	select season_id,seasonCode
	from tbl_season
</cfquery>

<H1 class="pageheading">NCSA - Log of Created Teams by Season <!--- #pageTitle# ---></H1>
<!--- <h2>For #VARIABLES.seasonSF# #VARIABLES.seasonYR# Teams </h2> --->


<FORM id="teamRegInfo" action="#cgi.script_name#" method="post">
	<input name="sort" type="hidden" value="team_id">
	<input name="order" type="hidden" value="asc">
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
	<div id="qplayLevel" class="question">
		<label for="playLevel" style="display: block;"><b>Play Level</b></label>
		<SELECT name="playLevel" id="playLevel"> 
			<OPTION value="" selected>Level</OPTION>
			<CFLOOP list="#lPlayLevel#" index="ita">
				<OPTION value="#ita#" <CFIF playLevel EQ ita>selected</CFIF>  >#ita#</OPTION>
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
	<div id="qSeason" class="question">
		<label for="Season" style="display: block;"><b>Select Season </b></label>
		<SELECT name="Season" id="Season">
			<CFLOOP query="#getSeasons#" >
				<OPTION value="#season_id#"  <cfif Season_id EQ variables.season>selected</cfif> > #seasonCode# </OPTION>
			</CFLOOP>
		</SELECT>
	</div>


<!--- 	<div id="qTeamFormed" class="question">
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
 --->
	<div id="qSubmit" class="question-submit">
		<input type="Submit" name="GETTEAM" value="Get Team">
		<input type="Submit" name="printme" value="Printer Friendly">
		<input type="Submit" name="Export" value="Export">
	</div>

</FORM>

<br>
<CFIF isDefined("FORM")>
	<cftry>
		<!--- CL.ClubAbbr + '-' + IsNull(T.Gender,'') + right(T.TeamAge,2) + IsNull(T.PlayLevel,'') + IsNull(T.PlayGroup,'')+ '-' + HC.LastName --->
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

		</CFQUERY>	
		<cfcatch><cfdump var='#cfcatch#' abort="true"></cfcatch>
	</Cftry>
	<div>Number of Teams: #registeredTeams.recordcount#</div>
	<div id="teamRegInfoResults">
		<table border="0" cellspacing="0" cellpadding="3" align="center" border="0" width="100%" id="teamResultsTable" class="tablesorter" style="table-layout:fixed;">
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
				<cfloop query="registeredTeams">	
					<tr>
						<td width="75" align="center">#prior_team_id#</td>
						<td width="75" align="center">#prior_team_name#</td>
						<td width="250" align="center">#team_id#</td>
						<td width="250" align="center">#teamnamederived#</td>
						<td width="50" align="center">#teamAge#</td>
						<td width="50" align="center">#playlevel#</td>
						<td width="50" align="center">#gender#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</div>
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
			$("th").click(function(){
				//console.log($(this).data('sort'));
				$('input[name=sort]').val($(this).data('sort'));
				//console.log($(this).data('order'));
				$('input[name=order]').val($(this).data('order'));
				if($(this).data('order') == 'asc')
					$(this).data('order','desc');
				else
					$(this).data('order','asc');
				
			});
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
